import 'package:flutter/material.dart';

class TrendingFlyCard extends StatelessWidget {
  final int rank;
  final String name;
  final String scientificName;
  final int identificationCount;
  final String imageUrl;
  final String category;

  const TrendingFlyCard({
    super.key,
    required this.rank,
    required this.name,
    required this.scientificName,
    required this.identificationCount,
    required this.imageUrl,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Rank indicator
          Container(
            width: 50,
            height: 100,
            decoration: BoxDecoration(
              color: _getRankColor(rank),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          
          // Fly image
          Container(
            width: 80,
            height: 100,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    scientificName,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$identificationCount identifications',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        _getCategoryIcon(category),
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Arrow
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return Colors.amber;
    if (rank == 2) return Colors.blueGrey;
    if (rank == 3) return Colors.brown;
    return Colors.orange;
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'This Week':
        return Icons.trending_up;
      case 'Your Region':
        return Icons.location_on;
      case 'Rare Finds':
        return Icons.star;
      default:
        return Icons.trending_up;
    }
  }
}

