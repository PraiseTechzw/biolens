import 'dart:io';
import 'dart:convert';
import 'package:afro_dip/models/fly_species.dart';
import 'package:afro_dip/models/identification_result.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  
  factory LocalStorageService() => _instance;
  
  LocalStorageService._internal();
  
  Database? _database;
  final String _databaseName = 'afro_dip.db';
  final int _databaseVersion = 1;
  
  // Initialize database
  Future<void> initialize() async {
    if (_database != null) return;
    
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, _databaseName);
      
      _database = await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _createDatabase,
      );
      
      // Create necessary directories
      await _createDirectories();
    } catch (e) {
      debugPrint('Error initializing local storage: $e');
    }
  }
  
  Future<void> _createDatabase(Database db, int version) async {
    // Identification results table
    await db.execute('''
      CREATE TABLE identification_results (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL,
        date INTEGER NOT NULL
      )
    ''');
    
    // Fly species table
    await db.execute('''
      CREATE TABLE fly_species (
        id TEXT PRIMARY KEY,
        data TEXT NOT NULL
      )
    ''');
    
    // Image mappings table (local path to cloud URL)
    await db.execute('''
      CREATE TABLE image_mappings (
        local_path TEXT PRIMARY KEY,
        cloud_url TEXT NOT NULL
      )
    ''');
    
    // Sync queue table
    await db.execute('''
      CREATE TABLE sync_queue (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        item_id TEXT NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
  }
  
  Future<void> _createDirectories() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      
      // Create images directory
      final imagesDir = Directory('${appDir.path}/images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      
      // Create models directory
      final modelsDir = Directory('${appDir.path}/models');
      if (!await modelsDir.exists()) {
        await modelsDir.create(recursive: true);
      }
    } catch (e) {
      debugPrint('Error creating directories: $e');
    }
  }
  
  // Identification results methods
  Future<void> saveIdentificationResult(IdentificationResult result) async {
    try {
      await _database?.insert(
        'identification_results',
        {
          'id': result.id,
          'data': jsonEncode(result.toJson()),
          'date': result.date.millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('Error saving identification result: $e');
    }
  }
  
  Future<IdentificationResult?> getIdentificationResult(String id) async {
    try {
      final maps = await _database?.query(
        'identification_results',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (maps != null && maps.isNotEmpty) {
        return IdentificationResult.fromJson(
          jsonDecode(maps.first['data'] as String),
        );
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting identification result: $e');
      return null;
    }
  }
  
  Future<List<IdentificationResult>> getIdentificationResults() async {
    try {
      final maps = await _database?.query(
        'identification_results',
        orderBy: 'date DESC',
      );
      
      if (maps != null && maps.isNotEmpty) {
        return maps.map((map) {
          return IdentificationResult.fromJson(
            jsonDecode(map['data'] as String),
          );
        }).toList();
      }
      
      return [];
    } catch (e) {
      debugPrint('Error getting identification results: $e');
      return [];
    }
  }
  
  Future<void> deleteIdentificationResult(String id) async {
    try {
      await _database?.delete(
        'identification_results',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('Error deleting identification result: $e');
    }
  }
  
  // Fly species methods
  Future<void> saveFlySpecies(FlySpecies species) async {
    try {
      await _database?.insert(
        'fly_species',
        {
          'id': species.id,
          'data': jsonEncode(species.toJson()),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('Error saving fly species: $e');
    }
  }
  
  Future<FlySpecies?> getFlySpeciesById(String id) async {
    try {
      final maps = await _database?.query(
        'fly_species',
        where: 'id = ?',
        whereArgs: [id],
      );
      
      if (maps != null && maps.isNotEmpty) {
        return FlySpecies.fromJson(
          jsonDecode(maps.first['data'] as String),
        );
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting fly species: $e');
      return null;
    }
  }
  
  Future<List<FlySpecies>> getFlySpecies() async {
    try {
      final maps = await _database?.query('fly_species');
      
      if (maps != null && maps.isNotEmpty) {
        return maps.map((map) {
          return FlySpecies.fromJson(
            jsonDecode(map['data'] as String),
          );
        }).toList();
      }
      
      return [];
    } catch (e) {
      debugPrint('Error getting fly species: $e');
      return [];
    }
  }
  
  // Image storage methods
  Future<String> saveImage(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/images');
      
      // Create a unique filename
      final uuid = const Uuid().v4();
      final extension = imageFile.path.split('.').last;
      final filename = '$uuid.$extension';
      
      // Copy the file to the images directory
      final savedFile = await imageFile.copy('${imagesDir.path}/$filename');
      
      return savedFile.path;
    } catch (e) {
      debugPrint('Error saving image: $e');
      return imageFile.path; // Return original path if saving fails
    }
  }
  
  Future<File?> getImage(String path) async {
    try {
      final file = File(path);
      
      if (await file.exists()) {
        return file;
      }
      
      // If the file doesn't exist at the given path, check if it's a cloud URL
      if (path.startsWith('http')) {
        // Look up the local path from the mapping
        final mapping = await _getImageMapping(path);
        if (mapping != null) {
          final localFile = File(mapping);
          if (await localFile.exists()) {
            return localFile;
          }
        }
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting image: $e');
      return null;
    }
  }
  
  Future<void> saveImageMapping(String localPath, String cloudUrl) async {
    try {
      await _database?.insert(
        'image_mappings',
        {
          'local_path': localPath,
          'cloud_url': cloudUrl,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('Error saving image mapping: $e');
    }
  }
  
  Future<String?> _getImageMapping(String cloudUrl) async {
    try {
      final maps = await _database?.query(
        'image_mappings',
        where: 'cloud_url = ?',
        whereArgs: [cloudUrl],
      );
      
      if (maps != null && maps.isNotEmpty) {
        return maps.first['local_path'] as String;
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting image mapping: $e');
      return null;
    }
  }
  
  // Sync queue methods
  Future<void> queueForSync(String type, String itemId) async {
    try {
      final uuid = const Uuid().v4();
      
      await _database?.insert(
        'sync_queue',
        {
          'id': uuid,
          'type': type,
          'item_id': itemId,
          'created_at': DateTime.now().millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('Error queuing for sync: $e');
    }
  }
  
  Future<List<String>> getQueuedItems(String type) async {
    try {
      final maps = await _database?.query(
        'sync_queue',
        where: 'type = ?',
        whereArgs: [type],
        orderBy: 'created_at ASC',
      );
      
      if (maps != null && maps.isNotEmpty) {
        return maps.map((map) => map['item_id'] as String).toList();
      }
      
      return [];
    } catch (e) {
      debugPrint('Error getting queued items: $e');
      return [];
    }
  }
  
  Future<void> removeFromSyncQueue(String type, String itemId) async {
    try {
      await _database?.delete(
        'sync_queue',
        where: 'type = ? AND item_id = ?',
        whereArgs: [type, itemId],
      );
    } catch (e) {
      debugPrint('Error removing from sync queue: $e');
    }
  }
  
  // Model storage methods
  Future<String> saveModel(File modelFile, String modelName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final modelsDir = Directory('${appDir.path}/models');
      
      // Save the model file
      final savedFile = await modelFile.copy('${modelsDir.path}/$modelName');
      
      return savedFile.path;
    } catch (e) {
      debugPrint('Error saving model: $e');
      return modelFile.path; // Return original path if saving fails
    }
  }
  
  Future<File?> getModel(String modelName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final modelsDir = Directory('${appDir.path}/models');
      final modelPath = '${modelsDir.path}/$modelName';
      
      final file = File(modelPath);
      if (await file.exists()) {
        return file;
      }
      
      return null;
    } catch (e) {
      debugPrint('Error getting model: $e');
      return null;
    }
  }
}

