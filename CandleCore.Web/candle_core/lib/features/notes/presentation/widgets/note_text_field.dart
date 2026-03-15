import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class NoteTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isDark;
  final int maxLines;
  final bool autofocus;

  const NoteTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.isDark,
    required this.maxLines,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      maxLines: maxLines,
      style: const TextStyle(fontSize: AppTypography.textBase),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: isDark
            ? AppColors.inputBackgroundDark
            : AppColors.inputBackgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
