import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/core/theme/app_theme.dart';
import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';

class RecipeListItem extends StatelessWidget {
  final RecipeEntity recipe;
  final bool showCategory;
  final VoidCallback onTap;

  const RecipeListItem({
    super.key,
    required this.recipe,
    required this.onTap,
    this.showCategory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: CachedNetworkImage(
                  imageUrl: recipe.image,
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 68,
                    height: 68,
                    color: AppColors.surfaceAlt,
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 68,
                    height: 68,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (showCategory) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        recipe.category,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
