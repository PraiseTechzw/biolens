import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:afro_dip/screens/results_screen.dart';
import 'package:afro_dip/widgets/advanced_analysis_overlay.dart';
import 'package:flutter/services.dart';
import 'package:afro_dip/utils/app_theme.dart';
import 'package:afro_dip/services/tflite_service.dart';
import 'package:afro_dip/services/firebase_service.dart';
import 'package:afro_dip/models/identification_result.dart';
import 'package:afro_dip/models/fly_species.dart';
import 'package:uuid/uuid.dart';

enum CaptureSource { camera, gallery }

class CaptureScreen extends StatefulWidget {
  final CaptureSource source;

  const CaptureScreen({
    super.key,
    required this.source,
  });

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isProcessing = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _showCameraPreview = false;
  bool _isTakingPicture = false;
  bool _isFlashOn = false;
  
  final TFLiteService _tfliteService = TFLiteService();
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _getImage();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }
  
  Future<void> _initializeServices() async {
    // Initialize TFLite service
    if (!_tfliteService.isInitialized) {
      await _tfliteService.initialize();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getImage() async {
    if (widget.source == CaptureSource.gallery) {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 80,
        );

        if (pickedFile == null) {
          // User canceled the picker
          Navigator.of(context).pop();
          return;
        }

        setState(() {
          _imageFile = File(pickedFile.path);
        });
        
        // Animate the image appearance
        _animationController.forward();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
        Navigator.of(context).pop();
      }
    } else {
      // For camera, we'll stay in the app and show the camera preview
      setState(() {
        _showCameraPreview = true;
      });
    }
  }

  Future<void> _takePicture() async {
    try {
      // Haptic feedback
      HapticFeedback.mediumImpact();
      
      setState(() {
        _isTakingPicture = true;
      });
      
      // Simulate taking a picture (in a real app, this would use the camera package)
      await Future.delayed(const Duration(milliseconds: 500));
      
      // For demo purposes, we'll use a placeholder image
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/captured_image.png');
      
      setState(() {
        _imageFile = tempFile;
        _showCameraPreview = false;
        _isTakingPicture = false;
      });
      
      // Animate the image appearance
      _animationController.forward();
    } catch (e) {
      setState(() {
        _isTakingPicture = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _processImage() async {
    if (_imageFile == null) return;

    // Haptic feedback
    HapticFeedback.mediumImpact();

    setState(() {
      _isProcessing = true;
    });

    try {
      // Use TFLite to identify the fly species
      final result = await _tfliteService.identifyFlySpecies(_imageFile!);
      
      // Upload image to Firebase Storage
      final imagePath = 'images/${const Uuid().v4()}.jpg';
      final imageUrl = await _firebaseService.uploadImage(_imageFile!, imagePath);
      
      // Get the identified species details
      final speciesId = result['species'];
      final confidence = result['confidence'] as double;
      
      // Get species details from Firebase or local storage
      FlySpecies? species = await _firebaseService.getFlySpeciesById(speciesId);
      
      // If species not found, create a placeholder
      if (species == null) {
        species = FlySpecies(
          id: speciesId,
          commonName: speciesId,
          scientificName: 'Unknown',
          family: 'Unknown',
          confidenceScore: confidence,
          description: 'Species information not available',
          habitat: 'Unknown',
          behavior: 'Unknown',
          healthRisks: 'Unknown',
          preventionTips: 'Unknown',
          imageUrl: imageUrl,
          geographicDistribution: 'Unknown',
        );
      } else {
        // Update confidence score
        species = species.copyWith(confidenceScore: confidence);
      }
      
      // Create identification result
      final identificationResult = IdentificationResult(
        id: const Uuid().v4(),
        species: species,
        confidenceScore: confidence,
        date: DateTime.now(),
        imageFilePath: imageUrl,
        location: 'Current Location', // In a real app, get actual location
      );
      
      // Save result to Firebase and local storage
      await _firebaseService.saveIdentificationResult(identificationResult);

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ResultsScreen(imageFile: _imageFile!),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.source == CaptureSource.camera
            ? 'Capture Fly'
            : 'Upload Image'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showTipsDialog();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_showCameraPreview)
            _buildCameraPreview()
          else if (_imageFile != null)
            Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.black,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: InteractiveViewer(
                            minScale: 0.5,
                            maxScale: 3.0,
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback for demo when file doesn't exist
                                return Container(
                                  color: Colors.black,
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 100,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Ready to identify this fly?',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Our AI will analyze the image and provide detailed information about the species.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isProcessing ? null : _getImage,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retake'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isProcessing ? null : _processImage,
                              icon: const Icon(Icons.search),
                              label: const Text('Identify'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.source == CaptureSource.camera
                        ? 'Initializing camera...'
                        : 'Opening gallery...',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          if (_isProcessing) const AdvancedAnalysisOverlay(
            message: 'Analyzing Image...',
            subMessage: 'Our AI is identifying the fly species with advanced pattern recognition',
          ),
        ],
      ),
    );
  }

Widget _buildCameraPreview() {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final primaryColor = isDarkMode 
      ? AppTheme.secondaryGreen 
      : AppTheme.primaryGreen;
  
  return Stack(
    children: [
      // Camera preview (simulated for this demo)
      Container(
        color: Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: 3/4,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.grey.shade900,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Simulated camera feed
                  Center(
                    child: Icon(
                      Icons.camera,
                      size: 100,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  
                  // Focus area
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: primaryColor.withOpacity(0.7),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.pest_control_outlined,
                            color: primaryColor.withOpacity(0.7),
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Position fly here',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Camera grid lines
                  CustomPaint(
                    size: Size.infinite,
                    painter: CameraGridPainter(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      
      // Camera controls overlay
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
            ),
          ),
          child: Column(
            children: [
              const Text(
                'Position the fly in the center',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Keep the camera steady for best results',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Flash toggle
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFlashOn = !_isFlashOn;
                      });
                      HapticFeedback.lightImpact();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isFlashOn 
                            ? primaryColor.withOpacity(0.3) 
                            : Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFlashOn ? Icons.flash_on : Icons.flash_off,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  
                  // Capture button
                  GestureDetector(
                    onTap: _isTakingPicture ? null : _takePicture,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryColor,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: _isTakingPicture
                          ? Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                                  strokeWidth: 3,
                                ),
                              ),
                            )
                          : Center(
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                    ),
                  ),
                  
                  // Gallery button
                  GestureDetector(
                    onTap: () async {
                      try {
                        final XFile? pickedFile = await _picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 80,
                        );

                        if (pickedFile == null) return;

                        setState(() {
                          _imageFile = File(pickedFile.path);
                          _showCameraPreview = false;
                        });
                        
                        // Animate the image appearance
                        _animationController.forward();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.photo_library,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
  
  void _showTipsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tips for Better Identification'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTipItem(
                Icons.light_mode,
                'Good Lighting',
                'Ensure the fly is well-lit to capture details clearly.',
              ),
              const SizedBox(height: 16),
              _buildTipItem(
                Icons.center_focus_strong,
                'Close-up Shot',
                'Get as close as possible without losing focus.',
              ),
              const SizedBox(height: 16),
              _buildTipItem(
                Icons.stay_current_portrait,
                'Multiple Angles',
                'If possible, take photos from different angles.',
              ),
              const SizedBox(height: 16),
              _buildTipItem(
                Icons.compare,
                'Size Reference',
                'Include a size reference like a coin if possible.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTipItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Camera grid painter class
class CameraGridPainter extends CustomPainter {
  final Color color;

  CameraGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw horizontal lines
    final horizontalSpacing = size.height / 3;
    for (int i = 1; i < 3; i++) {
      final y = horizontalSpacing * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Draw vertical lines
    final verticalSpacing = size.width / 3;
    for (int i = 1; i < 3; i++) {
      final x = verticalSpacing * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

