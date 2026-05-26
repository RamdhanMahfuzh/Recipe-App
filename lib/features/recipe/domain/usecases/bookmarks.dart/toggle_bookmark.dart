import 'package:recipe_app/features/recipe/data/models/recipe_bookmark_model.dart';
import 'package:recipe_app/features/recipe/data/repositories/recipe_bookmark_model.dart';

class ToggleBookmark {
  final RecipeBookmarkRepository repository;

  ToggleBookmark(this.repository);

  Future<void> call(RecipeBookmarkModel recipe) {
    return repository.toggleBookmark(recipe);
  }
}
