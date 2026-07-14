import 'package:flutter/material.dart';
import 'package:recipe_app/core/theme/app_theme.dart';

class InstructionsBox extends StatelessWidget {
  final String instructions;

  const InstructionsBox({super.key, required this.instructions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Text(
        instructions,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
