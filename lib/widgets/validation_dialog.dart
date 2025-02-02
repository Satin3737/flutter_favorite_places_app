import 'package:flutter/material.dart';

class ValidationDialog extends StatelessWidget {
  const ValidationDialog({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        'Validation Error',
        style: theme.textTheme.titleMedium!.copyWith(
          fontSize: 24,
          color: theme.colorScheme.onSurface,
        ),
      ),
      content: Text(
        message,
        style: theme.textTheme.titleMedium!.copyWith(
          fontSize: 16,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Okay'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
