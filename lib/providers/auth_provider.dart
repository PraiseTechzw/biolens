import 'package:flutter/material.dart';

class User {
  final String id;
  final String displayName;
  final String email;
  final String photoUrl;
  final int identifications;
  final int contributions;
  
  User({
    required this.id,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    this.identifications = 0,
    this.contributions = 0,
  });
}

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoggedIn = false;
  
  User? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  
  Future<void> login() async {
    // Simulate login
    await Future.delayed(const Duration(seconds: 1));
    
    _user = User(
      id: '1',
      displayName: 'John Doe',
      email: 'john.doe@example.com',
      photoUrl: '/placeholder.svg',
      identifications: 12,
      contributions: 5,
    );
    
    _isLoggedIn = true;
    notifyListeners();
  }
  
  Future<void> logout() async {
    // Simulate logout
    await Future.delayed(const Duration(seconds: 1));
    
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}

