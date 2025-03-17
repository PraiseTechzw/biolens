import 'package:flutter/material.dart';
import '../models/pest.dart';

class ActionCard extends StatelessWidget {
  final PestAction action;
  
  const ActionCard({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    // Convert string icon name to IconData
    IconData getIconData() {
      switch (action.iconName) {
        case 'access_time':
          return Icons.access_time;
        case 'bed':
          return Icons.bed;
        case 'checkroom':
          return Icons.checkroom;
        case 'sanitizer':
          return Icons.sanitizer;
        case 'back_hand':
          return Icons.back_hand;
        case 'calendar_today':
          return Icons.calendar_today;
        case 'water_drop':
          return Icons.water_drop;
        case 'air':
          return Icons.air;
        default:
          return Icons.info_outline;
      }
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                getIconData(),
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    action.description,
                    style: Theme.of(context).textTheme.bodyMedium,
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

