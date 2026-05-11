import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';

abstract class RecipeRepository {
  Future<List<RecipeEntity>> getRecipe(String query);
}

