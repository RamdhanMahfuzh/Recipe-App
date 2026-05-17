part of 'recipe_detail_bloc.dart';

abstract class RecipeDetailEvent {}

class OnGetRecipeDetail extends RecipeDetailEvent {
  final String id;

  OnGetRecipeDetail(this.id);
}