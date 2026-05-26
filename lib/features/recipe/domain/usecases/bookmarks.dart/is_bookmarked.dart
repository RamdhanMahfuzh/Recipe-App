import "package:recipe_app/features/recipe/data/repositories/recipe_bookmark_model.dart";

class IsBookmarked {
  final RecipeBookmarkRepository repository;

  IsBookmarked(this.repository);

  Future<bool> call(
    String id,
  ) {
    return repository.isBookmarked(
      id,
    );
  }
}