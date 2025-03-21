import 'dart:io';
import 'package:flutter/material.dart';
import 'package:afro_dip/models/fly_species.dart';
import 'package:afro_dip/screens/fly_details_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:afro_dip/widgets/fly_logo.dart';
import 'package:afro_dip/utils/app_theme.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class ResultsScreen extends StatefulWidget {
  final File imageFile;

  // Mock data for demonstration
  final FlySpecies _identifiedSpecies = FlySpecies(
    id: '1',
    commonName: 'Tsetse Fly',
    scientificName: 'Glossina morsitans',
    family: 'Glossinidae',
    confidenceScore: 0.92,
    description: 'The tsetse fly is a large, biting fly that feeds on the blood of vertebrate animals. They are known for transmitting trypanosomiasis, or sleeping sickness.',
    habitat: 'Sub-Saharan Africa, particularly in woodland and savanna areas',
    behavior: 'Blood-feeding, day-active flies that can detect hosts by sight, smell, and heat.',
    healthRisks: 'Vector for African trypanosomiasis (sleeping sickness) in humans and nagana in animals',
    preventionTips: 'Use insect repellent, wear light-colored clothing, avoid peak activity times',
    imageUrl: 'https://example.com/tsetse.jpg',
    geographicDistribution: 'Central and Southern Africa',
  );

  ResultsScreen({super.key, required this.imageFile});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showAnalysisOverlay = true;
  final List<String> _analysisPoints = [
    'Wing venation pattern matches Glossina genus',
    'Body proportions consistent with tsetse fly morphology',
    'Proboscis structure indicates blood-feeding behavior',
    'Color pattern matches Glossina morsitans species',
    'Size estimation: 8-14mm in length',
    'Distinctive wing-folding pattern identified',
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Hide analysis overlay after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showAnalysisOverlay = false;
        });
        // Provide haptic feedback when analysis completes
        HapticFeedback.mediumImpact();
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final species = widget._identifiedSpecies;
    
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Original image
                      Image.file(
                        widget.imageFile,
                        fit: BoxFit.cover,
                      ),
                      
                      // Gradient overlay
                      Container(
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
                      
                      // Confidence score badge
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${(species.confidenceScore * 100).toInt()}% Match',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Species name at bottom
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              species.commonName,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              species.scientificName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      _shareResults();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saved to favorites')),
                      );
                    },
                  ),
                ],
              ),
              
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tab bar for different views
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Overview'),
                        Tab(text: 'Analysis'),
                        Tab(text: 'Health Info'),
                      ],
                      labelColor: Theme.of(context).colorScheme.primary,
                      unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      indicatorColor: Theme.of(context).colorScheme.primary,
                    ),
                    
                    // Tab content
                    SizedBox(
                      height: 600, // Fixed height for tab content
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Overview Tab
                          _buildOverviewTab(species, context),
                          
                          // Analysis Tab
                          _buildAnalysisTab(context),
                          
                          // Health Info Tab
                          _buildHealthInfoTab(species, context),
                        ],
                      ),
                    ),
                    
                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Save to history
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Saved to history')),
                                );
                              },
                              icon: const Icon(Icons.bookmark_border),
                              label: const Text('Save'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => FlyDetailsScreen(species: species),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.info_outline),
                              label: const Text('Full Details'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Analysis overlay
          if (_showAnalysisOverlay)
            _buildAnalysisOverlay(),
        ],
      ),
    );
  }
  
  Widget _buildOverviewTab(FlySpecies species, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Classification card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Classification',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildClassificationRow('Family', species.family, context),
                _buildClassificationRow('Genus', species.scientificName.split(' ')[0], context),
                _buildClassificationRow('Species', species.scientificName.split(' ')[1], context),
                _buildClassificationRow('Common Name', species.commonName, context),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Quick facts
          Text(
            'Quick Facts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          _buildQuickFactItem(
            context,
            Icons.location_on_outlined,
            'Habitat',
            species.habitat,
          ),
          const Divider(),
          _buildQuickFactItem(
            context,
            Icons.psychology_outlined,
            'Behavior',
            species.behavior,
          ),
          const Divider(),
          _buildQuickFactItem(
            context,
            Icons.public_outlined,
            'Distribution',
            species.geographicDistribution,
          ),
          const SizedBox(height: 24),
          
          // Description
          Text(
            'Description',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            species.description,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnalysisTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Analysis visualization
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Fly outline visualization
                Center(
                  child: CustomPaint(
                    size: const Size(300, 150),
                    painter: FlyAnalysisPainter(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                
                // Measurement points
                Positioned(
                  top: 50,
                  left: 70,
                  child: _buildMeasurementPoint('Wing length: 7.5mm'),
                ),
                Positioned(
                  bottom: 40,
                  right: 80,
                  child: _buildMeasurementPoint('Body length: 12mm'),
                ),
                Positioned(
                  top: 100,
                  right: 60,
                  child: _buildMeasurementPoint('Proboscis: 3.2mm'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Analysis points
          Text(
            'Key Identification Markers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ..._analysisPoints.map((point) => _buildAnalysisPoint(point, context)),
          const SizedBox(height: 24),
          
          // Comparison with similar species
          Text(
            'Similar Species Comparison',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              children: [
                _buildSimilarSpeciesCard('Glossina palpalis', '78% similar', context),
                _buildSimilarSpeciesCard('Glossina fuscipes', '65% similar', context),
                _buildSimilarSpeciesCard('Stomoxys calcitrans', '42% similar', context),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHealthInfoTab(FlySpecies species, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Health risk alert
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.red.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Health Risk Alert',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        species.healthRisks,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Disease information
          Text(
            'Associated Diseases',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          _buildDiseaseCard(
            'African Trypanosomiasis',
            'Also known as sleeping sickness, this disease affects the central nervous system and can be fatal if untreated.',
            'Fever, headache, joint pain, progressive confusion, sleep disturbances',
            context,
          ),
          const SizedBox(height: 12),
          _buildDiseaseCard(
            'Animal Trypanosomiasis',
            'Also known as nagana, this disease affects livestock and can cause severe economic losses.',
            'Fever, anemia, weight loss, reproductive issues, death',
            context,
          ),
          const SizedBox(height: 24),
          
          // Prevention tips
          Text(
            'Prevention Tips',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          _buildPreventionTip(
            Icons.shield_outlined,
            'Use insect repellent containing DEET',
            context,
          ),
          _buildPreventionTip(
            Icons.checkroom_outlined,
            'Wear light-colored clothing that covers arms and legs',
            context,
          ),
          _buildPreventionTip(
            Icons.access_time,
            'Avoid outdoor activities during peak fly activity times',
            context,
          ),
          _buildPreventionTip(
            Icons.bed_outlined,
            'Sleep under insecticide-treated bed nets in endemic areas',
            context,
          ),
          _buildPreventionTip(
            Icons.medical_services_outlined,
            'Seek medical attention immediately if symptoms develop after a bite',
            context,
          ),
        ],
      ),
    );
  }
  
  Widget _buildClassificationRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontStyle: label == 'Genus' || label == 'Species' ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickFactItem(
    BuildContext context,
    IconData icon,
    String title,
    String content,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
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
                  content,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMeasurementPoint(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.straighten,
            size: 14,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnalysisPoint(String point, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              point,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSimilarSpeciesCard(String name, String similarity, BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlyLogo(
            size: 50,
            animate: false,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              similarity,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDiseaseCard(String name, String description, String symptoms, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Symptoms: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Expanded(
                child: Text(
                  symptoms,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPreventionTip(IconData icon, String tip, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
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
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnalysisOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.9),
      child: Stack(
        children: [
          // Background grid
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: AnalysisGridPainter(),
          ),
          
          // Image analysis visualization
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Fly image with scanning effect
                SizedBox(
                  width: 250,
                  height: 250,
                  child: Stack(
                    children: [
                      // Original image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          widget.imageFile,
                          fit: BoxFit.cover,
                        ),
                      ),
                      
                      // Scanning effect
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: const ScanningEffect(),
                      ),
                      
                      // Analysis points
                      Positioned(
                        top: 50,
                        left: 40,
                        child: _buildAnalysisMarker(),
                      ),
                      Positioned(
                        bottom: 70,
                        right: 60,
                        child: _buildAnalysisMarker(),
                      ),
                      Positioned(
                        top: 120,
                        right: 50,
                        child: _buildAnalysisMarker(),
                      ),
                      
                      // Border
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Analysis text
                Text(
                  'Advanced Image Analysis',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Identifying species characteristics...',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Progress indicators
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAnalysisProgressItem('Morphological analysis', 0.9),
                      const SizedBox(height: 8),
                      _buildAnalysisProgressItem('Pattern recognition', 0.75),
                      const SizedBox(height: 8),
                      _buildAnalysisProgressItem('Species matching', 0.85),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Data visualization on the sides
          Positioned(
            left: 16,
            top: 100,
            bottom: 100,
            width: 40,
            child: CustomPaint(
              painter: TechnicalDataPainter(
                animationValue: 0.7,
                direction: 'vertical',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          
          Positioned(
            right: 16,
            top: 100,
            bottom: 100,
            width: 40,
            child: CustomPaint(
              painter: TechnicalDataPainter(
                animationValue: 0.3,
                direction: 'vertical',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          
          // Bottom data visualization
          Positioned(
            left: 70,
            right: 70,
            bottom: 40,
            height: 30,
            child: CustomPaint(
              painter: TechnicalDataPainter(
                animationValue: 0.5,
                direction: 'horizontal',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnalysisMarker() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
  
  Widget _buildAnalysisProgressItem(String label, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Stack(
          children: [
            // Background
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            // Progress
            Container(
              height: 6,
              width: 300 * progress,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  void _shareResults() async {
    try {
      await Share.shareXFiles(
        [XFile(widget.imageFile.path)],
        text: 'I identified a ${widget._identifiedSpecies.commonName} (${widget._identifiedSpecies.scientificName}) using Afro-Dip!',
        subject: 'Fly Identification Results',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing: ${e.toString()}')),
        );
      }
    }
  }
}

class FlyAnalysisPainter extends CustomPainter {
  final Color color;
  
  FlyAnalysisPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw fly body outline
    final bodyPath = Path();
    bodyPath.moveTo(center.dx - 50, center.dy);
    bodyPath.quadraticBezierTo(
      center.dx - 40, center.dy - 30,
      center.dx, center.dy - 40,
    );
    bodyPath.quadraticBezierTo(
      center.dx + 40, center.dy - 30,
      center.dx + 50, center.dy,
    );
    bodyPath.quadraticBezierTo(
      center.dx + 40, center.dy + 30,
      center.dx, center.dy + 40,
    );
    bodyPath.quadraticBezierTo(
      center.dx - 40, center.dy + 30,
      center.dx - 50, center.dy,
    );
    canvas.drawPath(bodyPath, paint);
    
    // Draw wings
    final leftWingPath = Path();
    leftWingPath.moveTo(center.dx - 30, center.dy - 10);
    leftWingPath.quadraticBezierTo(
      center.dx - 80, center.dy - 40,
      center.dx - 100, center.dy,
    );
    leftWingPath.quadraticBezierTo(
      center.dx - 80, center.dy + 20,
      center.dx - 30, center.dy + 5,
    );
    canvas.drawPath(leftWingPath, paint);
    
    final rightWingPath = Path();
    rightWingPath.moveTo(center.dx + 30, center.dy - 10);
    rightWingPath.quadraticBezierTo(
      center.dx + 80, center.dy - 40,
      center.dx + 100, center.dy,
    );
    rightWingPath.quadraticBezierTo(
      center.dx + 80, center.dy + 20,
      center.dx + 30, center.dy + 5,
    );
    canvas.drawPath(rightWingPath, paint);
    
    // Draw head
    canvas.drawCircle(Offset(center.dx, center.dy - 35), 15, paint);
    
    // Draw wing veins
    final veinPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    
    // Left wing veins
    canvas.drawLine(
      Offset(center.dx - 30, center.dy - 5),
      Offset(center.dx - 90, center.dy - 20),
      veinPaint,
    );
    canvas.drawLine(
      Offset(center.dx - 30, center.dy),
      Offset(center.dx - 85, center.dy + 5),
      veinPaint,
    );
    canvas.drawLine(
      Offset(center.dx - 30, center.dy + 5),
      Offset(center.dx - 70, center.dy + 15),
      veinPaint,
    );
    
    // Right wing veins
    canvas.drawLine(
      Offset(center.dx + 30, center.dy - 5),
      Offset(center.dx + 90, center.dy - 20),
      veinPaint,
    );
    canvas.drawLine(
      Offset(center.dx + 30, center.dy),
      Offset(center.dx + 85, center.dy + 5),
      veinPaint,
    );
    canvas.drawLine(
      Offset(center.dx + 30, center.dy + 5),
      Offset(center.dx + 70, center.dy + 15),
      veinPaint,
    );
    
    // Draw measurement lines
    final measurePaint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    
    // Body length measurement
    canvas.drawLine(
      Offset(center.dx - 60, center.dy + 50),
      Offset(center.dx + 60, center.dy + 50),
      measurePaint,
    );
    canvas.drawLine(
      Offset(center.dx - 60, center.dy + 45),
      Offset(center.dx - 60, center.dy + 55),
      measurePaint,
    );
    canvas.drawLine(
      Offset(center.dx + 60, center.dy + 45),
      Offset(center.dx + 60, center.dy + 55),
      measurePaint,
    );
    
    // Wing span measurement
    canvas.drawLine(
      Offset(center.dx - 110, center.dy - 30),
      Offset(center.dx + 110, center.dy - 30),
      measurePaint,
    );
    canvas.drawLine(
      Offset(center.dx - 110, center.dy - 35),
      Offset(center.dx - 110, center.dy - 25),
      measurePaint,
    );
    canvas.drawLine(
      Offset(center.dx + 110, center.dy - 35),
      Offset(center.dx + 110, center.dy - 25),
      measurePaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class AnalysisGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    
    const gridSize = 30.0;
    
    // Draw vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Draw horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ScanningEffect extends StatefulWidget {
  const ScanningEffect({super.key});

  @override
  State<ScanningEffect> createState() => _ScanningEffectState();
}

class _ScanningEffectState extends State<ScanningEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    
    _controller.repeat(reverse: false);
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: ScanningEffectPainter(
            progress: _animation.value,
            color: Theme.of(context).colorScheme.primary,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class ScanningEffectPainter extends CustomPainter {
  final double progress;
  final Color color;
  
  ScanningEffectPainter({
    required this.progress,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Scanning line
    final scanY = size.height * progress;
    final scanPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    canvas.drawLine(
      Offset(0, scanY),
      Offset(size.width, scanY),
      scanPaint,
    );
    
    // Scanning glow
    final glowPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color.withOpacity(0.0),
          color.withOpacity(0.5),
          color.withOpacity(0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, scanY - 10, size.width, 20));
    
    canvas.drawRect(
      Rect.fromLTWH(0, scanY - 10, size.width, 20),
      glowPaint,
    );
    
    // Digital effect overlay
    final random = math.Random(progress.toInt() * 1000);
    final pixelPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final pixelSize = 1.0 + random.nextDouble() * 3.0;
      
      canvas.drawRect(
        Rect.fromLTWH(x, y, pixelSize, pixelSize),
        pixelPaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant ScanningEffectPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class TechnicalDataPainter extends CustomPainter {
  final double animationValue;
  final String direction;
  final Color color;
  final math.Random random = math.Random();
  
  TechnicalDataPainter({
    required this.animationValue,
    required this.direction,
    required this.color,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final barPaint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    if (direction == 'vertical') {
      // Draw background line
      canvas.drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        linePaint,
      );
      
      // Draw data bars
      const barCount = 20;
      final barSpacing = size.height / barCount;
      
      for (int i = 0; i < barCount; i++) {
        // Use a seeded random for consistent bar heights
        final barRandom = math.Random(i * 1000);
        
        // Base width percentage
        final baseWidth = 0.3 + barRandom.nextDouble() * 0.7;
        
        // Animation modifier
        final animOffset = math.sin(animationValue * 2 * math.pi + i * 0.3);
        final widthModifier = 0.7 + 0.3 * animOffset;
        
        final barWidth = size.width * baseWidth * widthModifier;
        final barHeight = barSpacing * 0.7;
        
        canvas.drawRect(
          Rect.fromLTWH(
            (size.width - barWidth) / 2,
            i * barSpacing + (barSpacing - barHeight) / 2,
            barWidth,
            barHeight,
          ),
          barPaint,
        );
      }
    } else {
      // Draw background line
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        linePaint,
      );
      
      // Draw data bars
      const barCount = 15;
      final barSpacing = size.width / barCount;
      
      for (int i = 0; i < barCount; i++) {
        // Use a seeded random for consistent bar heights
        final barRandom = math.Random(i * 1000);
        
        // Base height percentage
        final baseHeight = 0.3 + barRandom.nextDouble() * 0.7;
        
        // Animation modifier
        final animOffset = math.sin(animationValue * 2 * math.pi + i * 0.3);
        final heightModifier = 0.7 + 0.3 * animOffset;
        
        final barHeight = size.height * baseHeight * heightModifier;
        final barWidth = barSpacing * 0.7;
        
        canvas.drawRect(
          Rect.fromLTWH(
            i * barSpacing + (barSpacing - barWidth) / 2,
            (size.height - barHeight) / 2,
            barWidth,
            barHeight,
          ),
          barPaint,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant TechnicalDataPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

