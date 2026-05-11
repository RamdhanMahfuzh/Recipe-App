import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/injection.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_bloc.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key});

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
              return ListView.builder(
                itemCount: state.recipes.length,
                itemBuilder: (context, index) {
                  final recipe = state.recipes[index];

                  return ListTile(
                    leading: Image.network(
                      recipe.image,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(recipe.title),
                    subtitle: Text(recipe.category),
                  );
                },
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
