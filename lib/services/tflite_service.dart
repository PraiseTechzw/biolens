import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:afro_dip/models/fly_species.dart';
import 'package:afro_dip/services/local_storage_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class TFLiteService {
  static final TFLiteService _instance = TFLiteService._internal();
  
  factory TFLiteService() => _instance;
  
  TFLiteService._internal();
  
  Interpreter? _interpreter;
  List<String>? _labels;
  final LocalStorageService _localStorageService = LocalStorageService();
  
  bool get isInitialized => _interpreter != null;
  
  // Model configuration
  final int inputSize = 224;
  final int numChannels = 3;
  final int numClasses = 20; // Adjust based on your model
  
  // Initialize TFLite model
  Future<void> initialize() async {
    if (_interpreter != null) return;
    
    try {
      // Check if model exists in local storage
      final modelFile = await _localStorageService.getModel('fly_model.tflite');
      final labelsFile = await _localStorageService.getModel('fly_labels.txt');
      
      if (modelFile != null && labelsFile != null) {
        // Load model from local storage
        _interpreter = Interpreter.fromFile(modelFile);
        _labels = await _loadLabelsFromFile(labelsFile);
      } else {
        // Load model from assets
        await _loadModelFromAssets();
      }
      
      // Configure interpreter options
      final options = InterpreterOptions()..threads = 4;
      
      if (_interpreter == null) {
        final interpreterAddress = await Interpreter.fromAsset(
          'assets/models/fly_model.tflite',
          options: options,
        );
        _interpreter = interpreterAddress;
      }
      
      debugPrint('TFLite model initialized successfully');
    } catch (e) {
      debugPrint('Error initializing TFLite model: $e');
      // Fallback to asset loading if local storage fails
      await _loadModelFromAssets();
    }
  }
  
  Future<void> _loadModelFromAssets() async {
    try {
      // Load model from assets
      _interpreter = await Interpreter.fromAsset(
        'assets/models/fly_model.tflite',
        options: InterpreterOptions()..threads = 4,
      );
      
      // Load labels from assets
      final labelsData = await rootBundle.loadString('assets/models/fly_labels.txt');
      _labels = labelsData.split('\n');
      
      // Save model and labels to local storage for future use
      await _saveModelToLocalStorage();
      
      debugPrint('TFLite model loaded from assets successfully');
    } catch (e) {
      debugPrint('Error loading TFLite model from assets: $e');
    }
  }
  
  Future<void> _saveModelToLocalStorage() async {
    try {
      final tempDir = await getTemporaryDirectory();
      
      // Save model
      final modelBytes = await rootBundle.load('assets/models/fly_model.tflite');
      final modelFile = File('${tempDir.path}/fly_model.tflite');
      await modelFile.writeAsBytes(
        modelBytes.buffer.asUint8List(
          modelBytes.offsetInBytes,
          modelBytes.lengthInBytes,
        ),
      );
      await _localStorageService.saveModel(modelFile, 'fly_model.tflite');
      
      // Save labels
      final labelsBytes = await rootBundle.load('assets/models/fly_labels.txt');
      final labelsFile = File('${tempDir.path}/fly_labels.txt');
      await labelsFile.writeAsBytes(
        labelsBytes.buffer.asUint8List(
          labelsBytes.offsetInBytes,
          labelsBytes.lengthInBytes,
        ),
      );
      await _localStorageService.saveModel(labelsFile, 'fly_labels.txt');
      
      debugPrint('TFLite model saved to local storage successfully');
    } catch (e) {
      debugPrint('Error saving TFLite model to local storage: $e');
    }
  }
  
  Future<List<String>> _loadLabelsFromFile(File file) async {
    final labelsString = await file.readAsString();
    return labelsString.split('\n');
  }
  
  // Download and update model if a newer version is available
  Future<void> updateModelIfNeeded(String modelUrl, String labelsUrl, String version) async {
    try {
      // Check current model version
      final prefs = await SharedPreferences.getInstance();
      final currentVersion = prefs.getString('model_version') ?? '0';
      
      if (version.compareTo(currentVersion) > 0) {
        // Download new model
        final modelResponse = await http.get(Uri.parse(modelUrl));
        final labelsResponse = await http.get(Uri.parse(labelsUrl));
        
        if (modelResponse.statusCode == 200 && labelsResponse.statusCode == 200) {
          final tempDir = await getTemporaryDirectory();
          
          // Save model
          final modelFile = File('${tempDir.path}/fly_model.tflite');
          await modelFile.writeAsBytes(modelResponse.bodyBytes);
          await _localStorageService.saveModel(modelFile, 'fly_model.tflite');
          
          // Save labels
          final labelsFile = File('${tempDir.path}/fly_labels.txt');
          await labelsFile.writeAsBytes(labelsResponse.bodyBytes);
          await _localStorageService.saveModel(labelsFile, 'fly_labels.txt');
          
          // Update version
          await prefs.setString('model_version', version);
          
          // Reinitialize interpreter
          _interpreter?.close();
          _interpreter = Interpreter.fromFile(
            await _localStorageService.getModel('fly_model.tflite') ?? modelFile,
          );
          _labels = await _loadLabelsFromFile(
            await _localStorageService.getModel('fly_labels.txt') ?? labelsFile,
          );
          
          debugPrint('TFLite model updated to version $version');
        }
      }
    } catch (e) {
      debugPrint('Error updating TFLite model: $e');
    }
  }
  
  // Process image and identify fly species
  Future<Map<String, dynamic>> identifyFlySpecies(File imageFile) async {
    if (_interpreter == null) {
      await initialize();
    }
    
    try {
      // Preprocess image
      final imageData = await _preprocessImage(imageFile);
      
      // Run inference
      final outputBuffer = List<List<double>>.filled(
        1,
        List<double>.filled(numClasses, 0),
      );
      
      _interpreter!.run(imageData, outputBuffer);
      
      // Process results
      final results = outputBuffer[0];
      
      // Find top predictions
      final List<MapEntry<String, double>> predictions = [];
      
      for (var i = 0; i < results.length; i++) {
        if (i < _labels!.length) {
          predictions.add(MapEntry(_labels![i], results[i]));
        }
      }
      
      // Sort predictions by confidence (descending)
      predictions.sort((a, b) => b.value.compareTo(a.value));
      
      // Get top 3 predictions
      final top3Predictions = predictions.take(3).map((entry) {
        return {
          'label': entry.key,
          'confidence': entry.value,
        };
      }).toList();
      
      // Get the highest confidence prediction
      final topPrediction = predictions.first;
      
      return {
        'species': topPrediction.key,
        'confidence': topPrediction.value,
        'predictions': top3Predictions,
      };
    } catch (e) {
      debugPrint('Error identifying fly species: $e');
      return {
        'species': 'Unknown',
        'confidence': 0.0,
        'predictions': [],
        'error': e.toString(),
      };
    }
  }
  
  Future<List<List<List<double>>>> _preprocessImage(File imageFile) async {
    // Read image bytes
    final imageBytes = await imageFile.readAsBytes();
    
    // Decode image
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception('Failed to decode image');
    }
    
    // Resize image to match model input size
    final resizedImage = img.copyResize(
      image,
      width: inputSize,
      height: inputSize,
    );
    // Convert to RGB if needed
    final rgbImage = resizedImage.getBytes();
    
    // Normalize pixel values to [0, 1]
    final normalizedImage = List<List<List<double>>>.filled(
      1,
      List<List<double>>.filled(
        inputSize,
        List<double>.filled(inputSize * numChannels, 0),
      ),
    );
    
    // Reshape the flat RGB data into the required format
    int pixelIndex = 0;
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        for (int c = 0; c < numChannels; c++) {
          normalizedImage[0][y][x * numChannels + c] = rgbImage[pixelIndex++] / 255.0;
        }
      }
    }
    
    return normalizedImage;
  }
  
  // Clean up resources
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}




