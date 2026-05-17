import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/injection.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:recipe_app/features/recipe/presentation/pages/detail_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RecipeBloc>()..add(OnGetRecipes('')),
      child: Scaffold(
        appBar: AppBar(title: const Text('Recipe App')),
        body: BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, state) {
            if (state is RecipeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is RecipeLoaded) {
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
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _categoryItem(context, 'All', state.selectedCategory),
                        _categoryItem(context, 'Beef', state.selectedCategory),
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
                        _categoryItem(context, 'Side', state.selectedCategory),
                        _categoryItem(context, 'Pork', state.selectedCategory),
                        _categoryItem(context, 'Lamb', state.selectedCategory),
                        _categoryItem(context, 'Pasta', state.selectedCategory),
                        _categoryItem(
                          context,
                          'Dessert',
                          state.selectedCategory,
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: state.recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = state.recipes[index];

                        return Card(
                          margin: const EdgeInsetsDirectional.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            onTap: () {
                              context.push('/detail/${recipe.id}');
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(8),
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
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            if (state is RecipeError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
