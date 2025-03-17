import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/pest.dart';
import '../providers/report_provider.dart';
import '../services/pest_identifier.dart';
import '../widgets/risk_level_badge.dart';

class CreateReportScreen extends StatefulWidget {
  final String? initialImagePath;
  
  const CreateReportScreen({
    super.key,
    this.initialImagePath,
  });

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  
  File? _imageFile;
  Pest? _identifiedPest;
  bool _isIdentifying = false;
  bool _isSubmitting = false;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    if (widget.initialImagePath != null) {
      _imageFile = File(widget.initialImagePath!);
      _identifyPest();
    }
  }
  
  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
  
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _identifiedPest = null;
        _errorMessage = null;
      });
      
      _identifyPest();
    }
  }
  
  Future<void> _identifyPest() async {
    if (_imageFile == null || _isIdentifying) return;
    
    setState(() {
      _isIdentifying = true;
      _errorMessage = null;
    });
    
    try {
      final identifier = PestIdentifier();
      final pest = await identifier.identifyFromImage(_imageFile!.path);
      
      setState(() {
        _identifiedPest = pest;
        _isIdentifying = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isIdentifying = false;
      });
    }
  }
  
  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await Provider.of<ReportProvider>(context, listen: false).createReport(
        imageFile: _imageFile!,
        pest: _identifiedPest!,
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
      );
      
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Report'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image selection
              if (_imageFile == null)
                _buildImageSelector(context)
              else
                _buildImagePreview(context),
              
              // Identification result
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _isIdentifying
                      ? _buildIdentifyingState(context)
                      : _errorMessage != null
                          ? _buildErrorState(context)
                          : _identifiedPest != null
                              ? _buildIdentifiedState(context)
                              : const SizedBox.shrink(),
                ),
              
              // Form fields
              if (_identifiedPest != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pest Information',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      
                      // Description field
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Add details about the pest sighting...',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Location field
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          hintText: 'Enter the location where you saw the pest',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a location';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Submit button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitReport,
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Submit Report'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildImageSelector(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate,
            size: 64,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'Add Pest Photo',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: Text('Take Photo'),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: Text('From Gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildImagePreview(BuildContext context) {
    return Stack(
      children: [
        Image.file(
          _imageFile!,
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 8,
          right: 8,
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.5),
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => _pickImage(ImageSource.gallery),
              tooltip: 'Change Image',
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildIdentifyingState(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Identifying Pest',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a moment',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildErrorState(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.error_outline,
          size: 48,
          color: Colors.red,
        ),
        const SizedBox(height: 16),
        Text(
          'Identification Failed',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _errorMessage ?? 'Unknown Error',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red[700]),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _identifyPest,
          icon: const Icon(Icons.refresh),
          label: Text('Try Again'),
        ),
      ],
    );
  }
  
  Widget _buildIdentifiedState(BuildContext context) {
    final pest = _identifiedPest!;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pest.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        pest.scientificName,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                RiskLevelBadge(riskLevel: pest.riskLevel),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${pest.description.split('.').first}.',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

