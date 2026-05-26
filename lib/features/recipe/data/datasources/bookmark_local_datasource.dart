import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:recipe_app/features/recipe/data/models/recipe_model.dart';

abstract class BookmarkLocalDatasource {
  Future<void> saveBookmark(RecipeModel recipe);

  Future<void> removeBookmark(String id);

  List<RecipeModel> getBookmarks();

  bool isBookmarked(String id);
}

class BookmarkLocalDatasourceImpl
    implements BookmarkLocalDatasource {
      
  final Box<RecipeModel> box;

  BookmarkLocalDatasourceImpl(this.box);

  @override
  Future<void> saveBookmark(
    RecipeModel recipe,
  ) async {
    await box.put(
      recipe.id,
      recipe,
    );
  }

  @override
  Future<void> removeBookmark(
    String id,
  ) async {
    await box.delete(id);
  }

  @override
  List<RecipeModel> getBookmarks() {
    return box.values.toList();
  }

  @override
  bool isBookmarked(
    String id,
  ) {
    return box.containsKey(id);
  }
}