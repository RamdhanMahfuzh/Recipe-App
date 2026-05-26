import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:recipe_app/features/recipe/data/datasources/bookmark_local_datasource.dart';
import 'package:recipe_app/features/recipe/data/datasources/recipe_local_datasource.dart';
import 'package:recipe_app/features/recipe/data/datasources/recipe_remote_datasource.dart';
import 'package:recipe_app/features/recipe/data/models/recipe_bookmark_model.dart';
import 'package:recipe_app/features/recipe/data/models/recipe_model.dart';
import 'package:recipe_app/features/recipe/data/repositories/bookmark_repository.dart';
import 'package:recipe_app/features/recipe/data/repositories/recipe_bookmark_model.dart';
import 'package:recipe_app/features/recipe/data/repositories/recipe_repository.dart';
import 'package:recipe_app/features/recipe/domain/repositories/boomark_repository_impl.dart';
import 'package:recipe_app/features/recipe/domain/repositories/recipe_bookmark_repository_impl.dart';
import 'package:recipe_app/features/recipe/domain/repositories/recipe_repository_impl.dart';
import 'package:recipe_app/features/recipe/domain/usecases/bookmarks.dart/get_bookmarks.dart';
import 'package:recipe_app/features/recipe/domain/usecases/bookmarks.dart/is_bookmarked.dart';
import 'package:recipe_app/features/recipe/domain/usecases/bookmarks.dart/toggle_bookmark.dart';
import 'package:recipe_app/features/recipe/domain/usecases/recipes/get_recipe_by_category.dart';
import 'package:recipe_app/features/recipe/domain/usecases/recipes/get_recipe_random.dart';
import 'package:recipe_app/features/recipe/domain/usecases/recipes/get_recipes.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_bloc/recipe_bloc.dart';
import 'package:recipe_app/features/recipe/domain/usecases/recipes/get_recipe_detail.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_detail_bloc/recipe_detail_bloc.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_random_bloc/recipe_random_bloc.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/bookmark_bloc/bookmark_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Dio
  sl.registerLazySingleton(() => Dio());
  //  Datasource
  sl.registerLazySingleton<RecipeRemoteDatasource>(
    () => RecipeRemoteDatasourceimpl(sl()),
  );
  sl.registerLazySingleton<RecipeLocalDatasource>(
    () => RecipeLocalDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<BookmarkLocalDatasource>(
    () => BookmarkLocalDatasourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<RecipeRepository>(() => RecipeRepositoryImpl(sl()));
  sl.registerLazySingleton<RecipeBookmarkRepository>(
    () => RecipeBookmarkRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<BookmarkRepository>(
    () => BookmarkRepositoryImpl(sl()),
  );

  // Hive Box
  sl.registerLazySingleton<Box<RecipeModel>>(
    () => Hive.box<RecipeModel>('bookmarks'),
  );
  sl.registerLazySingleton<Box<RecipeBookmarkModel>>(
    () => Hive.box<RecipeBookmarkModel>('bookmarks'),
  );
  // Usecase
  sl.registerLazySingleton(() => GetRecipes(sl()));
  sl.registerLazySingleton(() => GetRecipeByCategory(sl()));
  sl.registerLazySingleton(() => GetRecipeDetail(sl()));
  sl.registerLazySingleton(() => GetRandomRecipe(sl()));
  sl.registerLazySingleton(() => GetBookmarks(sl()));
  sl.registerLazySingleton(() => ToggleBookmark(sl()));
  sl.registerLazySingleton(() => IsBookmarked(sl()));

  // Bloc
  sl.registerFactory(() => RecipeBloc(sl(), sl()));
  sl.registerFactory(() => RecipeDetailBloc(sl()));
  sl.registerFactory(() => RandomRecipeBloc(sl()));
  sl.registerFactory(() => BookmarkBloc(sl(), sl()));
}
