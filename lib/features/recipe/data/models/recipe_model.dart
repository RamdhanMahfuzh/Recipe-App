import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';

class RecipeModel extends RecipeEntity {
  const RecipeModel({
    required super.id,
    required super.title,
    required super.image,
    required super.instructions,
    required super.category,
    required super.ingredients,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add(ingredient);
      }
    }

    return RecipeModel(
      id: json['idMeal'],
      title: json['strMeal'],
      image: json['strMealThumb'],
      instructions: json['strInstructions'],
      category: json['strCategory'],
      ingredients: ingredients,
    );
  }
}
