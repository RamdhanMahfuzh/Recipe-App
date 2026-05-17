import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';
import 'package:recipe_app/features/recipe/domain/repositories/recipe_repository.dart';

class GetRecipeByCategory {
  final RecipeRepository repository;

  GetRecipeByCategory(this.repository);

  Future<List<RecipeEntity>> call(String category) {
    return repository.getRecipeByCategory(category);
  }
}
