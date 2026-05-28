import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
    return GestureDetector(
      onTap: () {
        context.read<RecipeBloc>().add(OnSelectCategory(category));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected == category ? Colors.orange : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          category,
          style: TextStyle(
            color: selected == category ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }

  // ================= SHIMMER HELPERS =================

  Widget _shimmerBox({double? width, double? height, BorderRadius? radius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _randomShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: double.infinity,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _shimmerBox(width: 60, height: 60),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(height: 12),
                      const SizedBox(height: 8),
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
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _shimmerBox(
              width: 80,
              height: 30,
              radius: BorderRadius.circular(20),
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
        backgroundColor: Color.fromARGB(255, 252, 246, 246),
        // ================== Appbar ===================
        appBar: AppBar(
          title: const Text(
            'EasyRecipe',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
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
              );
            }
            return BlocBuilder<RecipeBloc, RecipeState>(
              builder: (context, state) {
                if (state is RecipeLoading) {
                  return Column(
                    children: [
                      // SEARCH SHIMMER
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: _shimmerBox(
                          height: 55,
                          radius: BorderRadius.circular(12),
                        ),
                      ),

                      // CATEGORY SHIMMER
                      _categoryShimmer(),

                      const SizedBox(height: 12),

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
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search recipe...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onSubmitted: (value) {
                            context.read<RecipeBloc>().add(OnGetRecipes(value));
                          },
                        ),
                      ),

                      // Category
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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

                      // Random Recipe
                      BlocBuilder<RandomRecipeBloc, RandomRecipeState>(
                        builder: (context, state) {
                          if (state is RandomRecipeLoading) {
                            return _randomShimmer();
                          }

                          if (state is RandomRecipeLoaded) {
                            final recipe = state.recipe;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  context.push('/detail/${recipe.id}');
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                      image: NetworkImage(recipe.image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.8),
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
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          recipe.category,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
                                            fontSize: 12,
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

                      // List Tile
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ListView.builder(
                            itemCount: state.recipes.length,
                            itemBuilder: (context, index) {
                              final recipe = state.recipes[index];
                              return Card(
                                color: Colors.white,
                                shadowColor: Colors.grey,
                                margin: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 2,
                                  vertical: 4,
                                ),
                                child: ListTile(
                                  onTap: () {
                                    context.push('/detail/${recipe.id}');
                                  },
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      recipe.image,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(recipe.title),
                                  subtitle: state.selectedCategory == 'All'
                                      ? Text(recipe.category)
                                      : null,
                                  // trailing: IconButton(
                                  //   onPressed: () {},
                                  //   icon: Icon(Icons.bookmark_border),
                                  // ),
                                ),
                              );
                            },
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
