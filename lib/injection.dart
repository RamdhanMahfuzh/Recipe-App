import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:recipe_app/features/recipe/data/datasources/recipe_remote_datasource.dart';
import 'package:recipe_app/features/recipe/domain/repositories/recipe_repository.dart';
import 'package:recipe_app/features/recipe/domain/repositories/recipe_repository_impl.dart';
import 'package:recipe_app/features/recipe/domain/usecases/get_recipe_by_category.dart';
import 'package:recipe_app/features/recipe/domain/usecases/get_recipe_random.dart';
import 'package:recipe_app/features/recipe/domain/usecases/get_recipes.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_bloc.dart';
import 'package:recipe_app/features/recipe/domain/usecases/get_recipe_detail.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_detail_bloc.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_random_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => RecipeBloc(sl(), sl()));
  sl.registerFactory(() => RecipeDetailBloc(sl()));
  sl.registerFactory(() => RandomRecipeBloc(sl()));

  // Usecase
  sl.registerLazySingleton(() => GetRecipes(sl()));
  sl.registerLazySingleton(() => GetRecipeByCategory(sl()));
  sl.registerLazySingleton(() => GetRecipeDetail(sl()));
  sl.registerLazySingleton(() => GetRandomRecipe(sl()));

  // Repository
  sl.registerLazySingleton<RecipeRepository>(() => RecipeRepositoryImpl(sl()));
  //  Datasource
  sl.registerLazySingleton<RecipeRemoteDatasource>(
    () => RecipeRemoteDatasourceimpl(sl()),
  );
  // Dio
  sl.registerLazySingleton(() => Dio());
}
