part of 'recipe_random_bloc.dart';

abstract class RandomRecipeState {}

class RandomRecipeInitial extends RandomRecipeState {}

class RandomRecipeLoading extends RandomRecipeState {}

class RandomRecipeLoaded extends RandomRecipeState {
  final RecipeEntity recipe;

  RandomRecipeLoaded(this.recipe);
}

class RandomRecipeError extends RandomRecipeState {
  final String message;

  RandomRecipeError(this.message);
}