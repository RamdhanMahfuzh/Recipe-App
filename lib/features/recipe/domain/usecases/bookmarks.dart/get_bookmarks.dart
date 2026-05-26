import 'package:recipe_app/features/recipe/data/models/recipe_bookmark_model.dart';
import 'package:recipe_app/features/recipe/data/repositories/recipe_bookmark_model.dart';

class GetBookmarks {
  final RecipeBookmarkRepository repository;

  GetBookmarks(this.repository);

  Future<List<RecipeBookmarkModel>> call() {
    return repository.getBookmarks();
  }
}


