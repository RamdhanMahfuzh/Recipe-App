import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';
import 'package:recipe_app/features/recipe/domain/repositories/recipe_repository.dart';

class GetRecipeDetail {
  final RecipeRepository repository;

  GetRecipeDetail(this.repository);

  Future<RecipeEntity> call(String id) {
    return repository.getRecipeDetail(id);
  }
}
