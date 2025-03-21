import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:afro_dip/models/identification_result.dart';
import 'package:afro_dip/models/fly_species.dart';
import 'package:afro_dip/services/local_storage_service.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  
  factory FirebaseService() => _instance;
  
  FirebaseService._internal();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final LocalStorageService _localStorageService = LocalStorageService();
  
  // Authentication getters
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Initialize Firebase with offline persistence
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    
    // Enable Firestore offline persistence
    await _firestore.enablePersistence(
      const PersistenceSettings(synchronizeTabs: true),
    );
    
    // Set cache size to 100MB
    _firestore.settings = const Settings(
      cacheSizeBytes: 100 * 1024 * 1024, // 100MB
      persistenceEnabled: true,
    );
    
    // Initialize local storage service
    await _localStorageService.initialize();
  }
  
  // Authentication methods
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  Future<void> signOut() async {
    await _auth.signOut();
  }
  
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
  
  Future<void> updateUserProfile({String? displayName, String? photoURL}) async {
    if (_auth.currentUser != null) {
      await _auth.currentUser!.updateDisplayName(displayName);
      await _auth.currentUser!.updatePhotoURL(photoURL);
    }
  }
  
  // Firestore methods with offline support
  Future<void> saveIdentificationResult(IdentificationResult result) async {
    try {
      // First save locally
      await _localStorageService.saveIdentificationResult(result);
      
      // Check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        // If offline, queue for later sync
        await _localStorageService.queueForSync('identification_results', result.id);
        return;
      }
      
      // If online, save to Firestore
      if (_auth.currentUser != null) {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('identification_results')
            .doc(result.id)
            .set(result.toJson());
      }
    } catch (e) {
      debugPrint('Error saving identification result: $e');
      // If error, save to local queue for later sync
      await _localStorageService.queueForSync('identification_results', result.id);
    }
  }
  
  Future<List<IdentificationResult>> getIdentificationResults() async {
    try {
      // Check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      
      if (connectivityResult == ConnectivityResult.none || _auth.currentUser == null) {
        // If offline or not logged in, get from local storage
        return await _localStorageService.getIdentificationResults();
      }
      
      // If online, get from Firestore
      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('identification_results')
          .orderBy('date', descending: true)
          .get();
      
      final results = snapshot.docs
          .map((doc) => IdentificationResult.fromJson(doc.data()))
          .toList();
      
      // Update local storage with latest data
      for (var result in results) {
        await _localStorageService.saveIdentificationResult(result);
      }
      
      return results;
    } catch (e) {
      debugPrint('Error getting identification results: $e');
      // If error, fall back to local storage
      return await _localStorageService.getIdentificationResults();
    }
  }
  
  // Firebase Storage methods with local caching
  Future<String> uploadImage(File imageFile, String path) async {
    try {
      // Save image to local storage first
      final localPath = await _localStorageService.saveImage(imageFile);
      
      // Check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none || _auth.currentUser == null) {
        // If offline or not logged in, queue for later upload
        await _localStorageService.queueForSync('images', localPath);
        return localPath;
      }
      
      // If online, upload to Firebase Storage
      final storageRef = _storage.ref().child(path);
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      // Save the mapping between local path and cloud URL
      await _localStorageService.saveImageMapping(localPath, downloadUrl);
      
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      // If error, save locally and queue for later upload
      final localPath = await _localStorageService.saveImage(imageFile);
      await _localStorageService.queueForSync('images', localPath);
      return localPath;
    }
  }
  
  Future<File?> getImage(String path) async {
    try {
      // First try to get from local storage
      final localFile = await _localStorageService.getImage(path);
      if (localFile != null && await localFile.exists()) {
        return localFile;
      }
      
      // If not in local storage and path is a URL, download from Firebase Storage
      if (path.startsWith('http')) {
        final tempDir = await getTemporaryDirectory();
        final localPath = '${tempDir.path}/${path.split('/').last}';
        final file = File(localPath);
        
        // Check connectivity
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          return null; // Cannot download if offline
        }
        
        // Download file
        await _storage.refFromURL(path).writeToFile(file);
        
        // Save to local storage for future use
        final savedPath = await _localStorageService.saveImage(file);
        await _localStorageService.saveImageMapping(savedPath, path);
        
        return file;
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting image: $e');
      return null;
    }
  }
  
  // Sync methods
  Future<void> syncLocalData() async {
    try {
      // Check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none || _auth.currentUser == null) {
        return; // Cannot sync if offline or not logged in
      }
      
      // Sync queued identification results
      final queuedResults = await _localStorageService.getQueuedItems('identification_results');
      for (final resultId in queuedResults) {
        final result = await _localStorageService.getIdentificationResult(resultId);
        if (result != null) {
          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .collection('identification_results')
              .doc(result.id)
              .set(result.toJson());
          
          // Remove from queue after successful sync
          await _localStorageService.removeFromSyncQueue('identification_results', resultId);
        }
      }
      
      // Sync queued images
      final queuedImages = await _localStorageService.getQueuedItems('images');
      for (final imagePath in queuedImages) {
        final imageFile = await _localStorageService.getImage(imagePath);
        if (imageFile != null) {
          final storageRef = _storage.ref().child('images/${imagePath.split('/').last}');
          final uploadTask = storageRef.putFile(imageFile);
          final snapshot = await uploadTask;
          final downloadUrl = await snapshot.ref.getDownloadURL();
          
          // Save the mapping between local path and cloud URL
          await _localStorageService.saveImageMapping(imagePath, downloadUrl);
          
          // Remove from queue after successful sync
          await _localStorageService.removeFromSyncQueue('images', imagePath);
        }
      }
    } catch (e) {
      debugPrint('Error syncing local data: $e');
    }
  }
  
  // Fly species data methods
  Future<List<FlySpecies>> getFlySpecies() async {
    try {
      // First try to get from local storage
      final localSpecies = await _localStorageService.getFlySpecies();
      
      // Check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return localSpecies; // Return local data if offline
      }
      
      // If online, get from Firestore
      final snapshot = await _firestore.collection('fly_species').get();
      
      final species = snapshot.docs
          .map((doc) => FlySpecies.fromJson(doc.data()))
          .toList();
      
      // Update local storage with latest data
      for (var flySpecies in species) {
        await _localStorageService.saveFlySpecies(flySpecies);
      }
      
      return species.isNotEmpty ? species : localSpecies;
    } catch (e) {
      debugPrint('Error getting fly species: $e');
      // If error, fall back to local storage
      return await _localStorageService.getFlySpecies();
    }
  }
  
  Future<FlySpecies?> getFlySpeciesById(String id) async {
    try {
      // First try to get from local storage
      final localSpecies = await _localStorageService.getFlySpeciesById(id);
      
      // Check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return localSpecies; // Return local data if offline
      }
      
      // If online, get from Firestore
      final doc = await _firestore.collection('fly_species').doc(id).get();
      
      if (doc.exists) {
        final species = FlySpecies.fromJson(doc.data()!);
        // Update local storage
        await _localStorageService.saveFlySpecies(species);
        return species;
      }
      
      return localSpecies;
    } catch (e) {
      debugPrint('Error getting fly species by id: $e');
      // If error, fall back to local storage
      return await _localStorageService.getFlySpeciesById(id);
    }
  }
}

