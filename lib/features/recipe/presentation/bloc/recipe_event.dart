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
