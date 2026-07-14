import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/core/theme/app_theme.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_bloc/recipe_bloc.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_random_bloc/recipe_random_bloc.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/category_list.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/empty_recipe_widget.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/offline_recipe_widget.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/random_recipe_card.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/recipe_list_item.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/recipe_search_bar.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/recipe_shimmer.dart';
import 'package:recipe_app/injection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

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
        appBar: AppBar(
          title: const Text('EasyRecipe'),
          actions: [
            IconButton(
              onPressed: () => context.push('/bookmark'),
              icon: const Icon(Icons.bookmark, color: Colors.white),
            ),
          ],
        ),
        body: StreamBuilder<List<ConnectivityResult>>(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            final result = snapshot.data ?? [];
            final isOffline =
                result.isNotEmpty && result.first == ConnectivityResult.none;

            if (isOffline) {
              return OfflineRecipeWidget(
                onBookmarkTap: () => context.push('/bookmark'),
                onRetry: () =>
                    context.read<RecipeBloc>().add(OnGetRecipes('')),
              );
            }

            return BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                if (state is RecipeLoading) {
                  return const RecipePageShimmer();
                }

                if (state is RecipeLoaded) {
                  if (state.recipes.isEmpty) return const EmptyRecipeWidget();

                  return Column(
                    children: [
                      RecipeSearchBar(
                        onSubmitted: (value) =>
                            context.read<RecipeBloc>().add(OnGetRecipes(value)),
                      ),
                      CategoryList(selectedCategory: state.selectedCategory),
                      const RandomRecipeCard(),
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
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: AppSpacing.sm),
                              itemBuilder: (context, index) {
                                final recipe = state.recipes[index];
                                return RecipeListItem(
                                  recipe: recipe,
                                  showCategory:
                                      state.selectedCategory == 'All',
                                  onTap: () =>
                                      context.push('/detail/${recipe.id}'),
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
                      onBookmarkTap: () => context.push('/bookmark'),
                      onRetry: () =>
                          context.read<RecipeBloc>().add(OnGetRecipes('')),
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
