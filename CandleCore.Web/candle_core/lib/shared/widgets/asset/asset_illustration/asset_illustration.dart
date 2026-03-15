import 'package:candle_core/core/theme/tokens.dart';
import 'package:flutter/material.dart';

class AssetIllustration extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color iconColor;
  final double size;

  const AssetIllustration({
    required this.text,
    required this.backgroundColor,
    required this.iconColor,
    this.size = 50,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Text(
        text.length >= 2 ? text.substring(0, 2) : text,
        style: TextStyle(
          color: iconColor,
          fontSize: size * 0.34,
          fontWeight: AppTypography.fontWeightExtraBold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
