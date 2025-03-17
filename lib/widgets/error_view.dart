import 'package:flutter/material.dart';
import 'custom_button.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final String? buttonText;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorView({
    Key? key,
    required this.message,
    this.buttonText,
    this.onRetry,
    this.icon = Icons.error_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              CustomButton(
                text: buttonText ?? 'Try Again',
                onPressed: onRetry!,
                icon: Icons.refresh,
                type: ButtonType.outline,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NoConnectionView extends StatelessWidget {
  final VoidCallback onRetry;

  const NoConnectionView({
    Key? key,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorView(
      message: 'No internet connection. Please check your connection and try again.',
      buttonText: 'Retry',
      onRetry: onRetry,
      icon: Icons.wifi_off,
    );
  }
}

class EmptyStateView extends StatelessWidget {
  final String message;
  final String? buttonText;
  final VoidCallback? onAction;
  final IconData icon;

  const EmptyStateView({
    Key? key,
    required this.message,
    this.buttonText,
    this.onAction,
    this.icon = Icons.search_off,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ErrorView(
      message: message,
      buttonText: buttonText,
      onRetry: onAction,
      icon: icon,
    );
  }
}

