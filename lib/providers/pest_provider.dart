import 'package:flutter/material.dart';
import '../models/pest.dart';
import '../services/pest_storage.dart';

class PestProvider with ChangeNotifier {
  List<Pest> _recentPests = [];
  bool _isLoading = false;
  
  List<Pest> get recentPests => _recentPests;
  bool get isLoading => _isLoading;
  
  PestProvider() {
    _loadRecentPests();
  }
  
  Future<void> _loadRecentPests() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final storage = PestStorage();
      _recentPests = await storage.getRecentPests();
    } catch (e) {
      print('Error loading recent pests: $e');
      _recentPests = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> addPest(Pest pest) async {
    try {
      final storage = PestStorage();
      await storage.savePest(pest);
      
      // Add to the beginning of the list
      _recentPests.insert(0, pest);
      
      // Keep only the most recent 10 pests
      if (_recentPests.length > 10) {
        _recentPests = _recentPests.sublist(0, 10);
      }
      
      notifyListeners();
    } catch (e) {
      print('Error saving pest: $e');
    }
  }
}

