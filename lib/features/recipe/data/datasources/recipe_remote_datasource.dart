import 'package:dio/dio.dart';
import 'package:recipe_app/features/recipe/data/models/recipe_model.dart';

abstract class RecipeRemoteDatasource {
  Future<List<RecipeModel>> getRecipes(String query);
}

class RecipeRemoteDatasourceimpl implements RecipeRemoteDatasource {
  final Dio dio;

  RecipeRemoteDatasourceimpl(this.dio);

  @override
  Future<List<RecipeModel>> getRecipes(String query) async {
    // TODO: implement getRecipes
    final response = await dio.get(
      'https://www.themealdb.com/api/json/v1/1/search.php?s=$query',
    );
    final data = response.data['meals'];

    if (data == null) {
      return [];
    }

    return (data as List).map((json) => RecipeModel.fromJson(json)).toList();
  }
}
