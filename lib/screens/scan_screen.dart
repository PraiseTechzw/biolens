import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isAnalyzing = false;
  String? _predictedSpecies;
  double? _confidence;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _analyzeImage() async {
    if (_isAnalyzing) return;

    setState(() => _isAnalyzing = true);

    try {
      final image = await _controller.takePicture();
      // TODO: Implement TFLite model inference
      // This is a placeholder for the actual model inference
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _predictedSpecies = 'Tsetse Fly';
        _confidence = 0.96;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to analyze image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Fly'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CameraPreview(_controller),
                      if (_isAnalyzing)
                        const CircularProgressIndicator(),
                    ],
                  ),
                ),
                if (_predictedSpecies != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.black87,
                    child: Column(
                      children: [
                        Text(
                          'Predicted: $_predictedSpecies',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_confidence != null)
                          Text(
                            'Confidence: ${(_confidence! * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _predictedSpecies = null;
                                  _confidence = null;
                                });
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Scan Again'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Save result to history
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.save),
                              label: const Text('Save Result'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _analyzeImage,
        child: const Icon(Icons.camera),
      ),
    );
  }
} 