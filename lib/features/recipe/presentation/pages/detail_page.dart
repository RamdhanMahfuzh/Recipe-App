import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/core/theme/app_theme.dart';
import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_detail_bloc/recipe_detail_bloc.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/category_badge.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/ingredient_item.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/instructions_box.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/recipe_shimmer.dart';
import 'package:recipe_app/injection.dart';

class DetailPage extends StatelessWidget {
  final String? id;
  final RecipeEntity? recipe;

  const DetailPage({super.key, this.id, this.recipe});

  @override
  Widget build(BuildContext context) {
    if (recipe != null) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<BookmarkBloc>()..add(OnGetBookmarks()),
          ),
        ],
        child: _DetailContent(recipe: recipe!),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<RecipeDetailBloc>()..add(OnGetRecipeDetail(id!)),
        ),
        BlocProvider(create: (_) => sl<BookmarkBloc>()..add(OnGetBookmarks())),
      ],
      child: Scaffold(
        body: BlocBuilder<RecipeDetailBloc, RecipeDetailState>(
          builder: (context, state) {
            if (state is RecipeDetailLoading) {
              return const _DetailShimmer();
            }
            if (state is RecipeDetailLoaded) {
              return _DetailContent(recipe: state.recipe);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// ========================= Detail Content =========================

class _DetailContent extends StatelessWidget {
  final RecipeEntity recipe;

  const _DetailContent({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookmarkBloc, BookmarkState>(
      listener: (context, state) {
        if (state is BookmarkActionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: state.isAdded
                    ? AppColors.success
                    : AppColors.textPrimary,
                duration: const Duration(seconds: 2),
                content: Row(
                  children: [
                    Icon(
                      state.isAdded ? Icons.check_circle : Icons.delete,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.isAdded
                            ? 'Recipe successfully bookmarked'
                            : 'Recipe removed from bookmarks',
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // ---- Header Image ----
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: AppColors.primary,
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl: recipe.image,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(color: AppColors.surfaceAlt),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.surfaceAlt,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.textMuted,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),

            // ---- Content ----
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + bookmark button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            recipe.title,
                            style:
                                Theme.of(context).textTheme.headlineLarge,
                          ),
                        ),
                        BlocBuilder<BookmarkBloc, BookmarkState>(
                          builder: (context, state) {
                            final bookmarks = state is BookmarkLoaded
                                ? state.bookmarks
                                : <RecipeEntity>[];
                            final isBookmarked =
                                bookmarks.any((e) => e.id == recipe.id);
                            return IconButton(
                              onPressed: () {
                                context.read<BookmarkBloc>().add(
                                  OnToggleBookmark(recipe),
                                );
                              },
                              icon: Icon(
                                isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,
                                color: isBookmarked
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),
                    CategoryBadge(label: recipe.category),
                    const SizedBox(height: AppSpacing.xl),

                    Text(
                      'Ingredients',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    ...recipe.ingredients.map(
                      (ingredient) => IngredientItem(ingredient: ingredient),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    Text(
                      'Instructions',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    InstructionsBox(instructions: recipe.instructions),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================= Shimmer =========================

class _DetailShimmer extends StatelessWidget {
  const _DetailShimmer();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: Colors.transparent,
          leading: const BackButton(color: Colors.white),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(color: AppColors.surfaceAlt),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 28, width: 200),
                const SizedBox(height: 14),
                ShimmerBox(
                  height: 30,
                  width: 120,
                  radius: BorderRadius.circular(AppRadius.pill),
                ),
                const SizedBox(height: 24),
                ShimmerBox(height: 22, width: 150),
                const SizedBox(height: 12),
                ...List.generate(
                  5,
                  (_) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        const ShimmerBox(width: 8, height: 8),
                        const SizedBox(width: 10),
                        const Expanded(child: ShimmerBox(height: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ShimmerBox(height: 22, width: 160),
                const SizedBox(height: 12),
                ShimmerBox(
                  height: 180,
                  width: double.infinity,
                  radius: BorderRadius.circular(AppRadius.lg),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
