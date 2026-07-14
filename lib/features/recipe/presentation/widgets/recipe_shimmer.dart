import 'package:flutter/material.dart';
import 'package:recipe_app/core/theme/app_theme.dart';
import 'package:shimmer/shimmer.dart';

/// Satu shimmer box reusable — warna ikut warm-neutral palette.
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? radius;

  const ShimmerBox({super.key, this.width, this.height, this.radius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceAlt,
      highlightColor: AppColors.background,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: radius ?? BorderRadius.circular(AppRadius.sm),
        ),
      ),
    );
  }
}

/// Shimmer seluruh halaman home (search + kategori + random card + list).
class RecipePageShimmer extends StatelessWidget {
  const RecipePageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar shimmer
        Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ShimmerBox(
            height: 55,
            radius: BorderRadius.circular(AppRadius.md),
          ),
        ),

        // Category shimmer
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: 6,
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ShimmerBox(
                width: 80,
                height: 30,
                radius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // Random card shimmer
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: ShimmerBox(
            height: 160,
            radius: BorderRadius.circular(AppRadius.lg),
          ),
        ),

        // List shimmer
        Expanded(
          child: ListView.builder(
            itemCount: 6,
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  const ShimmerBox(width: 68, height: 68),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ShimmerBox(height: 14),
                        const SizedBox(height: AppSpacing.sm),
                        ShimmerBox(
                          width: 120,
                          height: 11,
                          radius: BorderRadius.circular(AppRadius.sm),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
