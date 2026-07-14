import 'package:flutter/material.dart';
import 'package:recipe_app/core/theme/app_theme.dart';

class RecipeSearchBar extends StatelessWidget {
  final ValueChanged<String> onSubmitted;

  const RecipeSearchBar({super.key, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search recipe...',
          prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
