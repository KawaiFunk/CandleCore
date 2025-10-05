import 'package:flutter/material.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SkipButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.secondary,
        padding: const EdgeInsets.only(top: 24),
        splashFactory: NoSplash.splashFactory,
        overlayColor: Colors.transparent,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      child: const Text('Skip'),
    );
  }
}
