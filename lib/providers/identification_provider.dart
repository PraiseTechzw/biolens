import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afro_dip/models/fly_species.dart';
import 'package:afro_dip/models/identification_result.dart';
import 'package:afro_dip/data/fly_species_data.dart';
import 'package:afro_dip/services/firebase_service.dart';
import 'package:afro_dip/services/local_storage_service.dart';
import 'dart:convert';
import 'dart:math';

class IdentificationProvider extends ChangeNotifier {
  List<IdentificationResult> _history = [];
  List<FlySpecies> _trendingSpecies = [];
  FlySpecies? _flyOfTheDay;
  bool _isLoading = false;
  bool _isSyncing = false;

  final FirebaseService _firebaseService = FirebaseService();
  final LocalStorageService _localStorageService = LocalStorageService();

  List<IdentificationResult> get history => _history;
  List<FlySpecies> get trendingSpecies => _trendingSpecies;
  FlySpecies? get flyOfTheDay => _flyOfTheDay;
  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;

  IdentificationProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _setLoading(true);
    
    try {
      await Future.wait([
        _loadHistory(),
        _loadTrendingSpecies(),
        _loadFlyOfTheDay(),
      ]);
    } catch (e) {
      debugPrint('Error loading identification data: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setSyncing(bool syncing) {
    _isSyncing = syncing;
    notifyListeners();
  }

  Future<void> _loadHistory() async {
    try {
      // Get history from Firebase with offline fallback
      _history = await _firebaseService.getIdentificationResults();
      
      // Sort by date, newest first
      _history.sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      debugPrint('Error loading history: $e');
      _history = [];
    }
  }

  Future<void> _loadTrendingSpecies() async {
    try {
      // Get trending species from Firebase
      final allSpecies = await _firebaseService.getFlySpecies();
      
      if (allSpecies.isEmpty) {
        // Fallback to local data if Firebase has no data
        final localSpecies = FlySpeciesData.getAllSpecies();
        
        // Shuffle and take first 10
        localSpecies.shuffle();
        _trendingSpecies = localSpecies.take(10).toList();
      } else {
        // Use Firebase data
        _trendingSpecies = allSpecies;
      }
      
      // Assign random identification counts if not present
      final random = Random();
      for (var i = 0; i < _trendingSpecies.length; i++) {
        if (_trendingSpecies[i].identificationCount == null) {
          final count = 100 - (i * 10) + random.nextInt(20);
          _trendingSpecies[i] = _trendingSpecies[i].copyWith(
            identificationCount: count,
          );
        }
      }
      
      // Sort by identification count
      _trendingSpecies.sort((a, b) => 
          (b.identificationCount ?? 0).compareTo(a.identificationCount ?? 0));
    } catch (e) {
      debugPrint('Error loading trending species: $e');
      _trendingSpecies = [];
    }
  }

  Future<void> _loadFlyOfTheDay() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastUpdateStr = prefs.getString('flyOfTheDayLastUpdate');
      
      // Check if we need to update the fly of the day
      final now = DateTime.now();
      final needsUpdate = lastUpdateStr == null || 
          DateTime.parse(lastUpdateStr).day != now.day;
      
      if (needsUpdate) {
        // Get all species from Firebase
        final allSpecies = await _firebaseService.getFlySpecies();
        
        if (allSpecies.isEmpty) {
          // Fallback to local data
          final localSpecies = FlySpeciesData.getAllSpecies();
          final random = Random();
          _flyOfTheDay = localSpecies[random.nextInt(localSpecies.length)];
        } else {
          // Select a random fly from Firebase data
          final random = Random();
          _flyOfTheDay = allSpecies[random.nextInt(allSpecies.length)];
        }
        
        // Save the new fly of the day and update timestamp
        await prefs.setString('flyOfTheDayJson', jsonEncode(_flyOfTheDay!.toJson()));
        await prefs.setString('flyOfTheDayLastUpdate', now.toIso8601String());
      } else {
        // Load the existing fly of the day
        final flyJson = prefs.getString('flyOfTheDayJson');
        if (flyJson != null) {
          _flyOfTheDay = FlySpecies.fromJson(jsonDecode(flyJson));
        } else {
          // Fallback if something went wrong
          final allSpecies = FlySpeciesData.getAllSpecies();
          _flyOfTheDay = allSpecies.first;
        }
      }
    } catch (e) {
      debugPrint('Error loading fly of the day: $e');
      // Fallback to a default species
      _flyOfTheDay = FlySpeciesData.getAllSpecies().first;
    }
  }

  Future<IdentificationResult> identifyImage(File imageFile, FlySpecies species, double confidenceScore) async {
    _setLoading(true);
    
    try {
      // Create the identification result
      final result = IdentificationResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        species: species,
        confidenceScore: confidenceScore,
        date: DateTime.now(),
        imageFilePath: imageFile.path,
      );
      
      // Save to Firebase and local storage
      await _firebaseService.saveIdentificationResult(result);
      
      // Add to history
      _history.insert(0, result);
      notifyListeners();
      
      return result;
    } catch (e) {
      debugPrint('Error identifying image: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteHistoryItem(String id) async {
    try {
      // Remove from local list
      _history.removeWhere((item) => item.id == id);
      notifyListeners();
      
      // Delete from Firebase and local storage
      await _localStorageService.deleteIdentificationResult(id);
      
      return true;
    } catch (e) {
      debugPrint('Error deleting history item: $e');
      return false;
    }
  }

  Future<bool> clearHistory() async {
    try {
      _history.clear();
      notifyListeners();
      
      // Clear from local storage
      final results = await _localStorageService.getIdentificationResults();
      for (final result in results) {
        await _localStorageService.deleteIdentificationResult(result.id);
      }
      
      return true;
    } catch (e) {
      debugPrint('Error clearing history: $e');
      return false;
    }
  }

  Future<void> syncWithFirebase() async {
    if (_isSyncing) return;
    
    _setSyncing(true);
    
    try {
      await _firebaseService.syncLocalData();
      await _loadHistory(); // Reload history after sync
      notifyListeners();
    } catch (e) {
      debugPrint('Error syncing with Firebase: $e');
    } finally {
      _setSyncing(false);
    }
  }

  List<IdentificationResult> getFilteredHistory({String? timeFilter}) {
    if (timeFilter == null || timeFilter == 'All Time') {
      return _history;
    }
    
    final now = DateTime.now();
    final filteredList = <IdentificationResult>[];
    
    for (final item in _history) {
      if (timeFilter == 'Today' && 
          item.date.day == now.day && 
          item.date.month == now.month && 
          item.date.year == now.year) {
        filteredList.add(item);
      } else if (timeFilter == 'This Week' && 
          now.difference(item.date).inDays < 7) {
        filteredList.add(item);
      } else if (timeFilter == 'This Month' && 
          item.date.month == now.month && 
          item.date.year == now.year) {
        filteredList.add(item);
      } else if (timeFilter == 'This Year' && 
          item.date.year == now.year) {
        filteredList.add(item);
      }
    }
    
    return filteredList;
  }

  List<FlySpecies> getRegionalTrendingSpecies(String region) {
    // In a real app, this would filter by the user's region
    // For demo, we'll just return a subset
    final random = Random();
    final filteredList = <FlySpecies>[];
    
    for (final species in _trendingSpecies) {
      if (random.nextBool()) {
        filteredList.add(species);
      }
    }
    
    if (filteredList.isEmpty) {
      return _trendingSpecies.take(5).toList();
    }
    
    return filteredList;
  }

  List<FlySpecies> getRareFinds() {
    // In a real app, this would return species with low identification counts
    // For demo, we'll just return a subset with modified counts
    final allSpecies = FlySpeciesData.getAllSpecies();
    final random = Random();
    
    // Take 5 random species
    allSpecies.shuffle();
    final rareSpecies = allSpecies.take(5).toList();
    
    // Assign low identification counts
    for (var i = 0; i < rareSpecies.length; i++) {
      rareSpecies[i] = rareSpecies[i].copyWith(
        identificationCount: random.nextInt(10) + 1,
      );
    }
    
    return rareSpecies;
  }
}

