part of 'recipe_detail_bloc.dart';

abstract class RecipeDetailState {}

class RecipeDetailInitial extends RecipeDetailState {}

class RecipeDetailLoading extends RecipeDetailState {}

class RecipeDetailLoaded extends RecipeDetailState {
  final RecipeEntity recipe;

  RecipeDetailLoaded(this.recipe);
}

class RecipeDetailError extends RecipeDetailState {
  final String message;

  RecipeDetailError(this.message);
}