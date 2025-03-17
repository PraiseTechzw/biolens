import 'package:flutter/material.dart';
import '../models/species.dart';
import '../services/species_service.dart';

class SpeciesProvider with ChangeNotifier {
  final SpeciesService _speciesService = SpeciesService();
  
  List<Species> _species = [];
  List<Species> _popularSpecies = [];
  List<Identification> _recentIdentifications = [];
  List<Species> _favorites = [];
  bool _isLoading = false;
  
  List<Species> get species => _species;
  List<Species> get popularSpecies => _popularSpecies;
  List<Identification> get recentIdentifications => _recentIdentifications;
  List<Species> get favorites => _favorites;
  bool get isLoading => _isLoading;
  
  Future<void> loadSpecies() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final species = await _speciesService.getSpecies();
      final popular = await _speciesService.getPopularSpecies();
      
      _species = species;
      _popularSpecies = popular;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
  
  void addRecentIdentification(Identification identification) {
    // Add to the beginning of the list
    _recentIdentifications.insert(0, identification);
    
    // Limit the list to 10 items
    if (_recentIdentifications.length > 10) {
      _recentIdentifications = _recentIdentifications.sublist(0, 10);
    }
    
    notifyListeners();
  }
  
  void addFavorite(Species species) {
    if (!_favorites.contains(species)) {
      _favorites.add(species);
      notifyListeners();
    }
  }
  
  void removeFavorite(Species species) {
    _favorites.removeWhere((s) => s.id == species.id);
    notifyListeners();
  }
}

