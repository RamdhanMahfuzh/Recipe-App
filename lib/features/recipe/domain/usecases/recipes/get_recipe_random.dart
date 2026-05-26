import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';
import 'package:recipe_app/features/recipe/data/repositories/recipe_repository.dart';

class GetRandomRecipe {
  final RecipeRepository repository;

  GetRandomRecipe(this.repository);

  Future<RecipeEntity> call() {
    return repository.getRandomRecipe();
  }
}