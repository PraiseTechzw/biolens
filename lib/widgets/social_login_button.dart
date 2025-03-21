import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SocialLoginButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        // Haptic feedback
        HapticFeedback.lightImpact();
        onPressed();
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            icon,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to icon if asset not found
              return Icon(
                label == 'Google' ? Icons.g_mobiledata : Icons.apple,
                size: 24,
              );
            },
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

