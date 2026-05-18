import 'package:connectivity_plus/connectivity_plus.dart';
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

  RecipeRemoteDatasourceimpl(this.dio) {
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.options.sendTimeout = const Duration(seconds: 5);
  }

  Future<void> checkInternet() async {
    final result = await Connectivity().checkConnectivity();

    if (result.contains(ConnectivityResult.none)) {
      throw Exception('offline');
    }
  }

  @override
  Future<List<RecipeModel>> getRecipes(String query) async {
    await checkInternet();
    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=$query',
      );

      final data = response.data['meals'];

      if (data == null) return [];

      return (data as List).map((json) => RecipeModel.fromJson(json)).toList();
    } on DioException {
      throw Exception('offline');
    }
  }

  @override
  Future<List<RecipeModel>> getByCategory(String category) async {
    await checkInternet();

    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category',
      );

      final data = response.data['meals'];

      if (data == null) return [];

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
    } on DioException {
      throw Exception('offline');
    }
  }

  @override
  Future<RecipeModel> getRecipeDetail(String id) async {
    await checkInternet();

    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id',
      );

      return RecipeModel.fromJson(response.data['meals'][0]);
    } on DioException {
      throw Exception('offline');
    }
  }

  @override
  Future<RecipeModel> getRandomRecipe() async {
    await checkInternet();

    try {
      final response = await dio.get(
        'https://www.themealdb.com/api/json/v1/1/random.php',
      );

      final data = response.data['meals'];

      return RecipeModel.fromJson(data[0]);
    } on DioException {
      throw Exception('offline');
    }
  }
}
