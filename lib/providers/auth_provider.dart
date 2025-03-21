
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  User? _user;
  Map<String, dynamic>? _userData;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  User? get user => _user;
  String? get email => _user?.email;
  String? get name => _userData?['name'] ?? _user?.displayName;
  String? get profileImageUrl => _userData?['profileImageUrl'] ?? _user?.photoURL;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _setLoading(true);
    try {
      // Listen for auth state changes
      _auth.authStateChanges().listen((User? user) {
        _user = user;
        if (user != null) {
          _loadUserData();
        } else {
          _userData = null;
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error initializing auth: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _loadUserData() async {
    if (_user == null) return;
    
    try {
      final docSnapshot = await _firestore.collection('users').doc(_user!.uid).get();
      
      if (docSnapshot.exists) {
        _userData = docSnapshot.data();
      } else {
        // Create user document if it doesn't exist
        final userData = {
          'email': _user!.email,
          'name': _user!.displayName,
          'profileImageUrl': _user!.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        };
        
        await _firestore.collection('users').doc(_user!.uid).set(userData);
        _userData = userData;
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    
    try {
      // Sign in with Firebase
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _user = userCredential.user;
      
      if (_user != null) {
        await _loadUserData();
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    
    try {
      // Create user with Firebase
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _user = userCredential.user;
      
      if (_user != null) {
        // Update display name
        await _user!.updateDisplayName(name);
        
        // Generate a profile image URL based on name
        final nameInitials = name.split(' ').map((part) => part.substring(0, 1).toUpperCase()).join('');
        final profileImageUrl = 'https://ui-avatars.com/api/?name=$nameInitials&background=2E7D32&color=fff&size=256';
        
        await _user!.updatePhotoURL(profileImageUrl);
        
        // Create user document in Firestore
        final userData = {
          'email': email,
          'name': name,
          'profileImageUrl': profileImageUrl,
          'createdAt': FieldValue.serverTimestamp(),
        };
        
        await _firestore.collection('users').doc(_user!.uid).set(userData);
        _userData = userData;
        
        // Reload user to get updated profile
        await _user!.reload();
        _user = _auth.currentUser;
        
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Registration error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Registration error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    
    try {
      await _auth.signOut();
      _user = null;
      _userData = null;
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Reset password error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Reset password error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({String? name, String? email, String? profileImageUrl}) async {
    _setLoading(true);
    
    try {
      if (_user == null) return false;
      
      // Update Firestore document
      final updates = <String, dynamic>{};
      
      if (name != null) updates['name'] = name;
      if (email != null && email != _user!.email) {
        // Update email in Firebase Auth
        await _user!.updateEmail(email);
        updates['email'] = email;
      }
      if (profileImageUrl != null) updates['profileImageUrl'] = profileImageUrl;
      
      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(_user!.uid).update(updates);
        
        // Update Firebase Auth profile
        if (name != null) await _user!.updateDisplayName(name);
        if (profileImageUrl != null) await _user!.updatePhotoURL(profileImageUrl);
        
        // Reload user data
        await _loadUserData();
      }
      
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Update profile error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Update profile error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updatePassword(String currentPassword, String newPassword) async {
    _setLoading(true);
    
    try {
      if (_user == null || _user!.email == null) return false;
      
      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: _user!.email!,
        password: currentPassword,
      );
      
      await _user!.reauthenticateWithCredential(credential);
      
      // Update password
      await _user!.updatePassword(newPassword);
      
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Update password error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Update password error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteAccount(String password) async {
    _setLoading(true);
    
    try {
      if (_user == null || _user!.email == null) return false;
      
      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: _user!.email!,
        password: password,
      );
      
      await _user!.reauthenticateWithCredential(credential);
      
      // Delete user data from Firestore
      await _firestore.collection('users').doc(_user!.uid).delete();
      
      // Delete user account
      await _user!.delete();
      
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Delete account error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Delete account error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
}

