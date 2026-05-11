import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/injection.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_bloc.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

  Widget _categoryItem(BuildContext context, String category) {
    return GestureDetector(
      onTap: () {
        context.read<RecipeBloc>().add(OnSelectCategory(category));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(category, style: const TextStyle(color: Colors.white)),
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
                        _categoryItem(context, 'Beef'),
                        _categoryItem(context, 'Chicken'),
                        _categoryItem(context, 'Seafood'),
                        _categoryItem(context, 'Dessert'),
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
                            subtitle: Text(recipe.category),
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
