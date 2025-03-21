import 'package:flutter/material.dart';
import 'package:afro_dip/models/fly_species.dart';
import 'package:afro_dip/screens/fly_details_screen.dart';
import 'package:flutter/services.dart';

class TrendingIdentificationsList extends StatelessWidget {
  const TrendingIdentificationsList({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final trendingIdentifications = List.generate(
      5,
      (index) => FlySpecies(
        id: 'trending-$index',
        commonName: 'Trending Fly ${index + 1}',
        scientificName: 'Scientificus trendus',
        family: 'Calliphoridae',
        confidenceScore: 0.9 + (index * 0.01),
        description: 'A trending fly species.',
        habitat: 'Various habitats',
        behavior: 'Common fly behavior',
        healthRisks: 'Minimal health risks',
        preventionTips: 'Standard prevention methods',
        imageUrl: 'https://example.com/trending$index.jpg',
        geographicDistribution: 'Global',
      ),
    );

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trendingIdentifications.length,
        itemBuilder: (context, index) {
          final fly = trendingIdentifications[index];
          
          return GestureDetector(
            onTap: () {
              // Haptic feedback
              HapticFeedback.mediumImpact();
              
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FlyDetailsScreen(species: fly),
                ),
              );
            },
            child: Container(
              width: 180,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fly image and rank
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.pest_control,
                            size: 50,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.trending_up,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '#${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Fly details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          const Spacer(),
                          Row(
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 14,
                                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${100 - (index * 15)} identifications',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 14,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Worldwide',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.primary,
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

