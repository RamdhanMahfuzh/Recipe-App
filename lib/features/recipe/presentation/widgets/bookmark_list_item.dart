import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/theme/app_theme.dart';
import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/bookmark_bloc/bookmark_bloc.dart';

class BookmarkListItem extends StatelessWidget {
  final RecipeEntity recipe;
  final bool isSelected;
  final VoidCallback onTap;

  const BookmarkListItem({
    super.key,
    required this.recipe,
    required this.isSelected,
    required this.onTap,
  });

  void _showRemoveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove Bookmark'),
          content: Text('Remove ${recipe.title}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
              ),
              onPressed: () {
                context.read<BookmarkBloc>().add(OnToggleBookmark(recipe));
                Navigator.pop(dialogContext);
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Row(
          children: [
            // Checkbox
            Checkbox(
              value: isSelected,
              onChanged: (_) {
                context.read<BookmarkBloc>().add(
                  OnToggleSelectBookmark(recipe.id),
                );
              },
            ),

            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: CachedNetworkImage(
                imageUrl: recipe.image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 60,
                  height: 60,
                  color: AppColors.surfaceAlt,
                ),
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 60,
                  color: AppColors.surfaceAlt,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // Title & category
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    recipe.category,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Remove button
            IconButton(
              onPressed: () => _showRemoveDialog(context),
              icon: const Icon(Icons.close, color: AppColors.danger),
            ),
          ],
        ),
      ),
    );
  }
}
