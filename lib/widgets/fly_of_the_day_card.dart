import 'package:flutter/material.dart';
import 'package:afro_dip/models/fly_species.dart';
import 'package:afro_dip/screens/fly_details_screen.dart';
import 'package:afro_dip/widgets/fly_logo.dart';
import 'package:flutter/services.dart';

class FlyOfTheDayCard extends StatelessWidget {
  const FlyOfTheDayCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    final flyOfTheDay = FlySpecies(
      id: '2',
      commonName: 'House Fly',
      scientificName: 'Musca domestica',
      family: 'Muscidae',
      confidenceScore: 1.0,
      description: 'The house fly is a fly of the suborder Cyclorrhapha. It is the most common fly species found in houses.',
      habitat: 'Worldwide, often near human habitation',
      behavior: 'Feeds on a variety of food sources including human food and waste',
      healthRisks: 'Can spread diseases by transferring bacteria from surfaces to food',
      preventionTips: 'Maintain cleanliness, use screens on windows, proper waste disposal',
      imageUrl: 'https://example.com/housefly.jpg',
      geographicDistribution: 'Global',
    );

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        // Haptic feedback
        HapticFeedback.mediumImpact();
        
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FlyDetailsScreen(species: flyOfTheDay),
          ),
        );
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    Color.lerp(Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.primary, 0.1)!,
                    Color.lerp(Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.primary, 0.2)!,
                  ]
                : [
                    Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.05)!,
                    Color.lerp(Colors.white, Theme.of(context).colorScheme.primary, 0.1)!,
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CustomPaint(
                  painter: DotPatternPainter(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  ),
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // Fly image
                  Hero(
                    tag: 'fly-of-the-day',
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: FlyLogo(
                        size: 100,
                        animate: true,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  
                  // Fly details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 14,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Fly of the Day',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          flyOfTheDay.commonName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          flyOfTheDay.scientificName,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          flyOfTheDay.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'View Details',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DotPatternPainter extends CustomPainter {
  final Color color;

  DotPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    const spacing = 20.0;
    
    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

