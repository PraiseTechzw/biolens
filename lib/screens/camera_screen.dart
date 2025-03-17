import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/species_provider.dart';
import '../services/identification_service.dart';
import '../models/species.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  
  const CameraScreen({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isIdentifying = false;
  File? _imageFile;
  final IdentificationService _identificationService = IdentificationService();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize camera controller
    if (widget.cameras.isNotEmpty) {
      _controller = CameraController(
        widget.cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      _initializeControllerFuture = _controller.initialize();
    }
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize the camera
    if (!_controller.value.isInitialized) {
      return;
    }
    
    if (state == AppLifecycleState.inactive) {
      _controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }
  
  Future<void> _initCamera() async {
    if (widget.cameras.isNotEmpty) {
      _controller = CameraController(
        widget.cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      _initializeControllerFuture = _controller.initialize();
    }
  }
  
  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      
      final image = await _controller.takePicture();
      setState(() {
        _imageFile = File(image.path);
      });
      
      _identifyImage();
    } catch (e) {
      print('Error taking picture: $e');
    }
  }
  
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      
      _identifyImage();
    }
  }
  
  Future<void> _identifyImage() async {
    if (_imageFile == null) return;
    
    setState(() {
      _isIdentifying = true;
    });
    
    try {
      final result = await _identificationService.identifyImage(_imageFile!);
      
      if (result != null) {
        // Add to recent identifications
        Provider.of<SpeciesProvider>(context, listen: false)
            .addRecentIdentification(result);
        
        // Navigate to species details
        Navigator.pushNamed(
          context,
          '/species_details',
          arguments: result.species,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error identifying image: $e')),
      );
    } finally {
      setState(() {
        _isIdentifying = false;
        _imageFile = null;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.cameras.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Identify')),
        body: const Center(
          child: Text('No camera available'),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(title: const Text('Identify')),
      body: Column(
        children: [
          Expanded(
            child: _imageFile != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                      ),
                      if (_isIdentifying)
                        Container(
                          color: Colors.black54,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    ],
                  )
                : FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_controller);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
          ),
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo_library, color: Colors.white, size: 32),
                  onPressed: _isIdentifying ? null : _pickImage,
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white, size: 48),
                  onPressed: _isIdentifying ? null : _takePicture,
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.white, size: 32),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('How to get the best results'),
                        content: const Text(
                          '1. Make sure the fly is in focus\n'
                          '2. Try to capture the fly from different angles\n'
                          '3. Good lighting helps with identification\n'
                          '4. If possible, include size reference'
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Got it'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

