import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/core/theme/app_theme.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_random_bloc/recipe_random_bloc.dart';
import 'package:recipe_app/injection.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_bloc/recipe_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/empty_recipe_widget.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/offline_recipe_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  Widget _categoryItem(BuildContext context, String category, String selected) {
    final isSelected = selected == category;
    return GestureDetector(
      onTap: () {
        context.read<RecipeBloc>().add(OnSelectCategory(category));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // ================= SHIMMER HELPERS =================

  Widget _shimmerBox({double? width, double? height, BorderRadius? radius}) {
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

  Widget _randomShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.surfaceAlt,
        highlightColor: AppColors.background,
        child: Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
    );
  }

  Widget _listShimmer() {
    return Expanded(
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                _shimmerBox(width: 60, height: 60),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(height: 12),
                      const SizedBox(height: AppSpacing.sm),
                      _shimmerBox(width: 120, height: 10),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _categoryShimmer() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: _shimmerBox(
              width: 80,
              height: 30,
              radius: BorderRadius.circular(AppRadius.pill),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<RecipeBloc>()..add(OnGetRecipes(''))),
        BlocProvider(
          create: (_) => sl<RandomRecipeBloc>()..add(OnGetRandomRecipe()),
        ),
      ],
      child: Scaffold(
        // ================== Appbar ===================
        appBar: AppBar(
          title: const Text('EasyRecipe'),
          actions: [
            IconButton(
              onPressed: () {
                context.push('/bookmark');
              },
              icon: const Icon(Icons.bookmark, color: Colors.white),
            ),
          ],
        ),
        // ========================= Body =========================
        body: StreamBuilder<List<ConnectivityResult>>(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            final result = snapshot.data ?? [];

            final isOffline =
                result.isNotEmpty && result.first == ConnectivityResult.none;
            if (isOffline) {
              return OfflineRecipeWidget(
                onBookmarkTap: () {
                  context.push('/bookmark');
                },

                onRetry: () {
                  context.read<RecipeBloc>().add(OnGetRecipes(''));
                },
              );
            }
            return BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                if (state is RecipeLoading) {
                  return Column(
                    children: [
                      // SEARCH SHIMMER
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: _shimmerBox(
                          height: 55,
                          radius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),

                      // CATEGORY SHIMMER
                      _categoryShimmer(),

                      const SizedBox(height: AppSpacing.md),

                      // RANDOM SHIMMER (tetap pakai bloc builder style)
                      _randomShimmer(),

                      // LIST SHIMMER
                      _listShimmer(),
                    ],
                  );
                }

                if (state is RecipeLoaded) {
                  if (state.recipes.isEmpty) {
                    return const EmptyRecipeWidget();
                  }
                  return Column(
                    children: [
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search recipe...',
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.textMuted,
                            ),
                          ),
                          onSubmitted: (value) {
                            context.read<RecipeBloc>().add(OnGetRecipes(value));
                          },
                        ),
                      ),
                      // Category Title
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Category",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                      // Category
                      const SizedBox(height: AppSpacing.sm),
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          children: [
                            _categoryItem(
                              context,
                              'All',
                              state.selectedCategory,
                            ),
                            _categoryItem(
                              context,
                              'Beef',
                              state.selectedCategory,
                            ),
                            _categoryItem(
                              context,
                              'Chicken',
                              state.selectedCategory,
                            ),
                            _categoryItem(
                              context,
                              'Seafood',
                              state.selectedCategory,
                            ),
                            _categoryItem(
                              context,
                              'Vegetarian',
                              state.selectedCategory,
                            ),
                            _categoryItem(
                              context,
                              'Side',
                              state.selectedCategory,
                            ),
                            _categoryItem(
                              context,
                              'Pork',
                              state.selectedCategory,
                            ),
                            _categoryItem(
                              context,
                              'Lamb',
                              state.selectedCategory,
                            ),
                            _categoryItem(
                              context,
                              'Pasta',
                              state.selectedCategory,
                            ),
                            _categoryItem(
                              context,
                              'Dessert',
                              state.selectedCategory,
                            ),
                            _categoryItem(
                              context,
                              'Miscellaneous',
                              state.selectedCategory,
                            ),
                          ],
                        ),
                      ),
                      // Random Recipe Title
                      Padding(
                        padding: const EdgeInsets.only(
                          left: AppSpacing.lg,
                          right: AppSpacing.lg,
                          top: AppSpacing.lg,
                          bottom: AppSpacing.xs,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Random Recipe",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),

                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                context.read<RandomRecipeBloc>().add(
                                  OnGetRandomRecipe(),
                                );
                              },
                              icon: const Icon(
                                Icons.casino_rounded,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Random Recipe
                      BlocBuilder<RandomRecipeBloc, RandomRecipeState>(
                        builder: (context, randomState) {
                          if (randomState is RandomRecipeLoading) {
                            return _randomShimmer();
                          }

                          if (randomState is RandomRecipeLoaded) {
                            final recipe = randomState.recipe;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.lg,
                                vertical: AppSpacing.md,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  context.push('/detail/${recipe.id}');
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.lg,
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(recipe.image),
                                      fit: BoxFit.cover,
                                    ),
                                    boxShadow: AppColors.softShadow(
                                      opacity: 0.12,
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                      AppSpacing.md,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.lg,
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withValues(alpha: 0.8),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recipe.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          recipe.category,
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          return const SizedBox();
                        },
                      ),

                      // Recipe List — only this part scrolls.
                      // ClipRect guarantees items never paint outside this
                      // area, even during fast scroll/overscroll, so the
                      // fixed header above is never visually overlapped.
                      Expanded(
                        child: ClipRect(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            child: ListView.separated(
                              clipBehavior: Clip.hardEdge,
                              padding: const EdgeInsets.only(
                                top: AppSpacing.sm,
                                bottom: AppSpacing.lg,
                              ),
                              itemCount: state.recipes.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: AppSpacing.sm),
                              itemBuilder: (context, index) {
                                final recipe = state.recipes[index];
                                return Material(
                                  color: AppColors.surface,
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.md,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      context.push('/detail/${recipe.id}');
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(
                                        AppSpacing.sm,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.border,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.md,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(
                                                  AppRadius.sm,
                                                ),
                                            child: Image.network(
                                              recipe.image,
                                              width: 68,
                                              height: 68,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: AppSpacing.md,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  recipe.title,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                                if (state.selectedCategory ==
                                                    'All') ...[
                                                  const SizedBox(
                                                    height: AppSpacing.xs,
                                                  ),
                                                  Text(
                                                    recipe.category,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                          const Icon(
                                            Icons.chevron_right,
                                            color: AppColors.textMuted,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                if (state is RecipeError) {
                  if (state.message.contains('offline')) {
                    return OfflineRecipeWidget(
                      onBookmarkTap: () {
                        context.push('/bookmark');
                      },

                      onRetry: () {
                        context.read<RecipeBloc>().add(OnGetRecipes(''));
                      },
                    );
                  }

                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            );
          },
        ),
      ),
    );
  }
}
