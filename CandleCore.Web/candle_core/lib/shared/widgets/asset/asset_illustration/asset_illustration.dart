import 'package:candle_core/core/theme/tokens.dart';
import 'package:flutter/material.dart';

class AssetIllustration extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color iconColor;

  const AssetIllustration({
    required this.text,
    required this.backgroundColor,
    required this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Text(
        text.substring(0, 2),
        style: TextStyle(
          color: iconColor,
          fontSize: 18,
          fontWeight: AppTypography.fontWeightExtraBold,
        ),
        textAlign: TextAlign.center
      ),
    );
  }
}
