import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pest.dart';

class PestStorage {
  static const String _recentPestsKey = 'recent_pests';
  
  Future<void> savePest(Pest pest) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing pests
    final recentPests = await getRecentPests();
    
    // Add new pest to the beginning
    recentPests.insert(0, pest);
    
    // Keep only the most recent 10 pests
    final pestsToSave = recentPests.length > 10 
        ? recentPests.sublist(0, 10) 
        : recentPests;
    
    // Convert to JSON and save
    final jsonList = pestsToSave.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_recentPestsKey, jsonList);
  }
  
  Future<List<Pest>> getRecentPests() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_recentPestsKey) ?? [];
    
    return jsonList
        .map((jsonString) => Pest.fromJson(jsonDecode(jsonString)))
        .toList();
  }
  
  Future<void> clearRecentPests() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentPestsKey);
  }
}

