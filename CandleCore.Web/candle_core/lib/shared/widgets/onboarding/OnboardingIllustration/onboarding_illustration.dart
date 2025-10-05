import 'package:flutter/material.dart';

class OnboardingIllustration extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const OnboardingIllustration({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      width: 128,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 70),
    );
  }
}
