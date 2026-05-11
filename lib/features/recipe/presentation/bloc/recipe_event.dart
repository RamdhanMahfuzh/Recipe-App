part of 'recipe_bloc.dart';

sealed class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

final class OnGetRecipes extends RecipeEvent {
  final String query;

  const OnGetRecipes(this.query);

  @override
  List<Object> get props => [query];
}

final class OnSelectCategory extends RecipeEvent {
  final String category;

  const OnSelectCategory(this.category);

  @override
  List<Object> get props => [category];
}

final class OnToggleBookmark extends RecipeEvent {
  final RecipeEntity recipe;

  const OnToggleBookmark(this.recipe);

  @override
  List<Object> get props => [recipe];
}
