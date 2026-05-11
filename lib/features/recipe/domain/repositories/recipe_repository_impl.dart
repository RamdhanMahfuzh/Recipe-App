import 'package:recipe_app/features/recipe/data/datasources/recipe_remote_datasource.dart';
import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';
import 'package:recipe_app/features/recipe/domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDatasource remoteDatasource;

  RecipeRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<RecipeEntity>> getRecipe(String query) async {
    final result = await remoteDatasource.getRecipes(query);
    return result;
  }
}
