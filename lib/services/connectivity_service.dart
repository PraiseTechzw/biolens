import 'dart:async';
import 'package:afro_dip/services/firebase_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  
  factory ConnectivityService() => _instance;
  
  ConnectivityService._internal();
  
  final Connectivity _connectivity = Connectivity();
  final FirebaseService _firebaseService = FirebaseService();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  
  bool _isOnline = true;
  bool get isOnline => _isOnline;
  
  // Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial connectivity
    final connectivityResult = await _connectivity.checkConnectivity();
    _isOnline = connectivityResult != ConnectivityResult.none;
    
    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  
  void _updateConnectionStatus(ConnectivityResult result) async {
    final wasOffline = !_isOnline;
    _isOnline = result != ConnectivityResult.none;
    
    // If we're coming back online after being offline, sync data
    if (_isOnline && wasOffline) {
      debugPrint('Back online, syncing data...');
      await _firebaseService.syncLocalData();
    }
  }
  
  // Check if we're online
  Future<bool> checkConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    _isOnline = connectivityResult != ConnectivityResult.none;
    return _isOnline;
  }
  
  // Dispose of resources
  void dispose() {
    _connectivitySubscription.cancel();
  }
}

