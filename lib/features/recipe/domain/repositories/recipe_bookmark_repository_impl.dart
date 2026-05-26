import 'package:recipe_app/features/recipe/data/datasources/recipe_local_datasource.dart';
import 'package:recipe_app/features/recipe/data/models/recipe_bookmark_model.dart';
import 'package:recipe_app/features/recipe/data/repositories/recipe_bookmark_model.dart';


class RecipeBookmarkRepositoryImpl
    implements RecipeBookmarkRepository {

  final RecipeLocalDatasource
      localDatasource;

  RecipeBookmarkRepositoryImpl(
    this.localDatasource,
  );

  @override
  Future<void> toggleBookmark(
    RecipeBookmarkModel recipe,
  ) {
    return localDatasource
        .toggleBookmark(recipe);
  }

  @override
  Future<List<RecipeBookmarkModel>>
  getBookmarks() {

    return localDatasource
        .getBookmarks();
  }

  @override
  Future<bool> isBookmarked(
    String id,
  ) {

    return localDatasource
        .isBookmarked(id);
  }
}