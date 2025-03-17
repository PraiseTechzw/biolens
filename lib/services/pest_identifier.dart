import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../models/pest.dart';
import '../data/pest_database.dart';

class PestIdentifier {
  static const int inputSize = 224;
  static const String modelPath = 'assets/model/pest_model.tflite';
  static const String labelsPath = 'assets/model/pest_labels.txt';
  
  Interpreter? _interpreter;
  List<String>? _labels;
  
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      final labelsData = await rootBundle.loadString(labelsPath);
      _labels = labelsData.split('\n');
    } catch (e) {
      print('Error loading model: $e');
      rethrow;
    }
  }
  
  Future<img.Image> _loadAndProcessImage(String imagePath) async {
    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    final image = img.decodeImage(imageBytes)!;
    
    // Resize the image to match the input size of the model
    final resizedImage = img.copyResize(
      image,
      width: inputSize,
      height: inputSize,
    );
    
    return resizedImage;
  }
  
  Future<List<double>> _runInference(img.Image image) async {
    if (_interpreter == null) {
      await _loadModel();
    }
    
    // Convert the image to a format suitable for the model
    final inputBuffer = Float32List(1 * inputSize * inputSize * 3);
    int pixelIndex = 0;
    
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        final pixel = image.getPixel(x, y);
        // Normalize pixel values to [0, 1]
        inputBuffer[pixelIndex++] = pixel.r / 255.0;
        inputBuffer[pixelIndex++] = pixel.g / 255.0;
        inputBuffer[pixelIndex++] = pixel.b / 255.0;
      }
    }
    
    // Reshape input tensor
    final input = [inputBuffer.reshape([1, inputSize, inputSize, 3])];
    
    // Output tensor shape [1, number_of_classes]
    final outputShape = _interpreter!.getOutputTensor(0).shape;
    final outputSize = outputShape[1];
    final output = [Float32List(1 * outputSize)];
    
    // Run inference
    _interpreter!.run(input, output);
    
    // Get the result
    final result = output[0] as Float32List;
    
    // Convert to List<double>
    return result.toList();
  }
  
  Future<String> _getTopLabel(List<double> predictions) async {
    if (_labels == null) {
      await _loadModel();
    }
    
    // Find the index with the highest probability
    int maxIndex = 0;
    double maxProb = predictions[0];
    
    for (int i = 1; i < predictions.length; i++) {
      if (predictions[i] > maxProb) {
        maxProb = predictions[i];
        maxIndex = i;
      }
    }
    
    // Return the corresponding label
    return _labels![maxIndex];
  }
  
  // For demo purposes, we'll simulate the identification process
  Future<Pest> identifyFromImage(String imagePath) async {
    // In a real app, we would:
    // 1. Load and process the image
    // 2. Run inference with the TFLite model
    // 3. Get the top prediction
    // 4. Look up the pest in the database
    
    // For now, we'll simulate a delay and return a mock pest
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate different results based on the time
    final second = DateTime.now().second;
    
    if (second % 3 == 0) {
      return PestDatabase.getTsetseFly();
    } else if (second % 3 == 1) {
      return PestDatabase.getFallArmyworm();
    } else {
      return PestDatabase.getMalarialMosquito();
    }
  }
}

