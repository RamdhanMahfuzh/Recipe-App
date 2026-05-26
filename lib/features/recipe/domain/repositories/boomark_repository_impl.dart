import 'package:recipe_app/features/recipe/data/datasources/bookmark_local_datasource.dart';
import 'package:recipe_app/features/recipe/data/models/recipe_model.dart';
import 'package:recipe_app/features/recipe/data/repositories/bookmark_repository.dart';
import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';


class BookmarkRepositoryImpl
    implements BookmarkRepository {

  final BookmarkLocalDatasource localDatasource;

  BookmarkRepositoryImpl(
    this.localDatasource,
  );

  @override
  Future<void> saveBookmark(
    RecipeEntity recipe,
  ) async {

    final model = RecipeModel(
      id: recipe.id,
      title: recipe.title,
      category: recipe.category,
      image: recipe.image,
      ingredients: recipe.ingredients,
      instructions: recipe.instructions,
    );

    await localDatasource
        .saveBookmark(model);
  }

  @override
  Future<void> removeBookmark(
    String id,
  ) async {

    await localDatasource
        .removeBookmark(id);
  }

@override
Future<List<RecipeEntity>> getBookmarks() async {

  final result =
      await localDatasource
          .getBookmarks();

  return result
      .map(
        (e) => e.toEntity(),
      )
      .toList();
}

  @override
  Future<bool> isBookmarked(
    String id,
  ) async {

    return localDatasource
        .isBookmarked(id);
  }
}