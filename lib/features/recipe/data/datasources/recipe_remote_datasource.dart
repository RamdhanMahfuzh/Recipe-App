import 'package:dio/dio.dart';
import 'package:recipe_app/features/recipe/data/models/recipe_model.dart';

abstract class RecipeRemoteDatasource {
  Future<List<RecipeModel>> getRecipes(String query);
  Future<List<RecipeModel>> getByCategory(String category);
  Future<RecipeModel> getRecipeDetail(String id);
  Future<RecipeModel> getRandomRecipe();
}

class RecipeRemoteDatasourceimpl implements RecipeRemoteDatasource {
  final Dio dio;

  RecipeRemoteDatasourceimpl(this.dio);

  @override
  Future<List<RecipeModel>> getRecipes(String query) async {
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

  @override
  Future<RecipeModel> getRandomRecipe() async {
    final response = await dio.get(
      'https://www.themealdb.com/api/json/v1/1/random.php',
    );

    final data = response.data['meals'];

    if (data == null || data.isEmpty) {
      throw Exception('No random meal found');
    }

    return RecipeModel.fromJson(data[0]);
  }
}
