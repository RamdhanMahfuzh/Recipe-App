import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';
import 'package:recipe_app/features/recipe/domain/repositories/recipe_repository.dart';

class GetRecipes {
  final RecipeRepository repository;

  GetRecipes(this.repository);
  Future<List<RecipeEntity>> call(String query) async {
    return await repository.getRecipe(query);
  }
}
