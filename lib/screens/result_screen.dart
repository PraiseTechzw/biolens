import 'package:flutter/material.dart';
import 'dart:io';
import '../models/pest.dart';
import '../services/pest_identifier.dart';
import '../widgets/action_card.dart';
import '../widgets/risk_level_badge.dart';

class ResultScreen extends StatefulWidget {
  final String imagePath;
  
  const ResultScreen({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isLoading = true;
  Pest? _identifiedPest;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _identifyPest();
  }

  Future<void> _identifyPest() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _identifiedPest = null;
    });
    
    try {
      final identifier = PestIdentifier();
      final pest = await identifier.identifyFromImage(widget.imagePath);
      
      if (!mounted) return;
      
      setState(() {
        _identifiedPest = pest;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identification Results'),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage != null || _identifiedPest == null
              ? _buildErrorState()
              : _buildResultsState(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Analyzing image...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Identification Failed',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'An unknown error occurred',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _identifyPest,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsState() {
    if (_identifiedPest == null) {
      return _buildErrorState();
    }

    final pest = _identifiedPest!;
    
    // Verify the image file exists
    final imageFile = File(widget.imagePath);
    if (!imageFile.existsSync()) {
      return _buildErrorState();
    }
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and identification header
          Stack(
            children: [
              // Image
              SizedBox(
                width: double.infinity,
                height: 250,
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Identification text
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pest.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      pest.scientificName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Risk level
                Row(
                  children: [
                    Text(
                      'Risk Level: ',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(width: 8),
                    RiskLevelBadge(riskLevel: pest.riskLevel),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Description
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(pest.description),
                
                const SizedBox(height: 24),
                
                // Immediate actions
                Text(
                  'Immediate Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                ...pest.actions.map((action) => ActionCard(action: action)).toList(),
                
                const SizedBox(height: 24),
                
                // Local resources
                Text(
                  'Local Resources',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.store),
                    title: const Text('Nearby Agro Shops'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Implement nearby shops functionality
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

