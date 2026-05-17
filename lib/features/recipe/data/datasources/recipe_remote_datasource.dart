import 'package:dio/dio.dart';
import 'package:recipe_app/features/recipe/data/models/recipe_model.dart';

abstract class RecipeRemoteDatasource {
  Future<List<RecipeModel>> getRecipes(String query);
  Future<List<RecipeModel>> getByCategory(String category);
  Future<RecipeModel> getRecipeDetail(String id);
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

  @override
  Future<List<RecipeModel>> getByCategory(String category) async {
    final response = await dio.get(
      'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category',
    );

    final data = response.data['meals'];

    if (data == null) {
      return [];
    }

    return (data as List)
        .map(
          (json) => RecipeModel(
            id: json['idMeal'] ?? '',
            title: json['strMeal'] ?? '',
            image: json['strMealThumb'] ?? '',

            // isi secukupnya
            category: category,

            instructions: '',

            ingredients: [],
          ),
        )
        .toList();
  }

  @override
  Future<RecipeModel> getRecipeDetail(String id) async {
    final response = await dio.get(
      'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id',
    );

    final data = response.data['meals'];

    return RecipeModel.fromJson(data[0]);
  }
}
