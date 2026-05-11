part of 'recipe_bloc.dart';

sealed class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

final class RecipeInitial extends RecipeState {}

final class RecipeLoading extends RecipeState {}

final class RecipeLoaded extends RecipeState {
  final List<RecipeEntity> recipes;

  const RecipeLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];
}

final class RecipeError extends RecipeState {
  final String message;

  const RecipeError(this.message);

  @override
  List<Object> get props => [message];
}

final class RecipeBookmarkLoaded extends RecipeState {
  final List<RecipeEntity> bookmarks;

  const RecipeBookmarkLoaded(this.bookmarks);

  @override
  List<Object> get props => [bookmarks];
}
