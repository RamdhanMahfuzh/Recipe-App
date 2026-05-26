import 'package:recipe_app/features/recipe/data/models/recipe_bookmark_model.dart';

abstract class RecipeBookmarkRepository {

  Future<void> toggleBookmark(
    RecipeBookmarkModel recipe,
  );

  Future<List<RecipeBookmarkModel>>
  getBookmarks();

  Future<bool> isBookmarked(
    String id,
  );
}