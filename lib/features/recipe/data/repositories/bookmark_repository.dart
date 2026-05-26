import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';

abstract class BookmarkRepository {
  Future<void> saveBookmark(
    RecipeEntity recipe,
  );

  Future<void> removeBookmark(
    String id,
  );

  Future<List<RecipeEntity>> getBookmarks();

  Future<bool> isBookmarked(
    String id,
  );
}