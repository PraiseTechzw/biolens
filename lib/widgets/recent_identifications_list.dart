import 'package:flutter/material.dart';
import 'package:afro_dip/models/fly_species.dart';
import 'package:afro_dip/screens/fly_details_screen.dart';
import 'package:afro_dip/screens/results_screen.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class RecentIdentificationsList extends StatelessWidget {
  const RecentIdentificationsList({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final recentIdentifications = List.generate(
      5,
      (index) => FlySpecies(
        id: 'recent-$index',
        commonName: 'Recent Fly ${index + 1}',
        scientificName: 'Scientificus recentus',
        family: 'Muscidae',
        confidenceScore: 0.85 + (index * 0.02),
        description: 'A recently identified fly species.',
        habitat: 'Various habitats',
        behavior: 'Common fly behavior',
        healthRisks: 'Minimal health risks',
        preventionTips: 'Standard prevention methods',
        imageUrl: 'https://example.com/recent$index.jpg',
        geographicDistribution: 'Local region',
      ),
    );

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentIdentifications.length,
        itemBuilder: (context, index) {
          final fly = recentIdentifications[index];
          
          return GestureDetector(
            onTap: () {
              // Haptic feedback
              HapticFeedback.mediumImpact();
              
              // In a real app, we would navigate to the actual results screen
              // For demo, we'll create a temporary file and navigate to results
              final tempDir = Directory.systemTemp;
              final tempFile = File('${tempDir.path}/temp_image.png');
              
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ResultsScreen(imageFile: tempFile),
                ),
              );
            },
            child: Container(
              width: 280,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Fly image
                  Container(
                    width: 100,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.pest_control,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  
                  // Fly details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${(fly.confidenceScore * 100).toInt()}% Match',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${2 + index} days ago',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            fly.commonName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            fly.scientificName,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Backyard, Home Garden',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

