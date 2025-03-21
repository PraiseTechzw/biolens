import 'package:flutter/material.dart';
import 'package:afro_dip/models/fly_species.dart';

class FlyDetailsScreen extends StatelessWidget {
  final FlySpecies species;

  const FlyDetailsScreen({
    super.key,
    required this.species,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(species.commonName),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    species.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        child: const Center(
                          child: Icon(
                            Icons.pest_control,
                            size: 80,
                            color: Colors.white54,
                          ),
                        ),
                      );
                    },
                  ),
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
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scientific name and classification
                  Text(
                    species.scientificName,
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Family: ${species.family}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Description
                  _buildSection(
                    context,
                    'Description',
                    species.description,
                  ),
                  
                  // Geographic Distribution
                  _buildSection(
                    context,
                    'Geographic Distribution',
                    species.geographicDistribution,
                    icon: Icons.map_outlined,
                  ),
                  
                  // Habitat
                  _buildSection(
                    context,
                    'Habitat',
                    species.habitat,
                    icon: Icons.terrain_outlined,
                  ),
                  
                  // Behavior
                  _buildSection(
                    context,
                    'Behavior',
                    species.behavior,
                    icon: Icons.psychology_outlined,
                  ),
                  
                  // Health Risks
                  _buildSection(
                    context,
                    'Health Risks',
                    species.healthRisks,
                    icon: Icons.warning_amber_outlined,
                    isWarning: true,
                  ),
                  
                  // Prevention Tips
                  _buildSection(
                    context,
                    'Prevention Tips',
                    species.preventionTips,
                    icon: Icons.shield_outlined,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Related Species (Mock data)
                  const Text(
                    'Related Species',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.pest_control,
                                  size: 40,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Related Fly ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content, {
    IconData? icon,
    bool isWarning = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: isWarning
                      ? Colors.orange
                      : Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

