import 'package:flutter/material.dart';
import '../models/pest.dart';

class RiskLevelBadge extends StatelessWidget {
  final RiskLevel riskLevel;
  
  const RiskLevelBadge({
    super.key,
    required this.riskLevel,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor = Colors.white;
    String label;
    
    switch (riskLevel) {
      case RiskLevel.low:
        backgroundColor = Colors.green;
        label = 'Low';
        break;
      case RiskLevel.medium:
        backgroundColor = Colors.orange;
        label = 'Medium';
        break;
      case RiskLevel.high:
        backgroundColor = Colors.red;
        label = 'High';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

