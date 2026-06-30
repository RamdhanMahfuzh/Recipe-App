import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipe_app/core/theme/app_theme.dart';

class OfflineRecipeWidget extends StatelessWidget {
  final VoidCallback onBookmarkTap;
  final VoidCallback onRetry;

  const OfflineRecipeWidget({
    super.key,
    required this.onBookmarkTap,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.32,
              child: SvgPicture.asset(
                'assets/images/offline.svg',
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Text(
              "You're in offline mode",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: AppSpacing.xs),

            Text(
              "Connect to the internet to browse recipes",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: AppSpacing.xl),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onBookmarkTap,
                icon: const Icon(Icons.bookmark, size: 18),
                label: const Text("Go to saved recipes"),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: onRetry,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text(
                  "Try again",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
