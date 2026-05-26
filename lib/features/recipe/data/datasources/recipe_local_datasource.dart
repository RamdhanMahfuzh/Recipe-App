import 'package:hive_ce/hive.dart';
import 'package:recipe_app/features/recipe/data/models/recipe_bookmark_model.dart';

abstract class RecipeLocalDatasource {
  Future<void> toggleBookmark(RecipeBookmarkModel recipe);

  Future<List<RecipeBookmarkModel>> getBookmarks();

  Future<bool> isBookmarked(String id);
}

class RecipeLocalDatasourceImpl implements RecipeLocalDatasource {
  final Box<RecipeBookmarkModel> box;

  RecipeLocalDatasourceImpl(this.box);

  @override
  Future<void> toggleBookmark(RecipeBookmarkModel recipe) async {
    if (box.containsKey(recipe.id)) {
      await box.delete(recipe.id);
    } else {
      await box.put(recipe.id, recipe);
    }
  }

  @override
  Future<List<RecipeBookmarkModel>> getBookmarks() async {
    return box.values.toList();
  }

  @override
  Future<bool> isBookmarked(String id) async {
    return box.containsKey(id);
  }
}
