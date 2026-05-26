import 'package:hive_ce/hive.dart';
import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';

part 'recipe_bookmark_model.g.dart';

@HiveType(typeId: 0)
class RecipeBookmarkModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final List<String> ingredients;

  @HiveField(5)
  final String instructions;

  RecipeBookmarkModel({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
    required this.ingredients,
    required this.instructions,
  });

  factory RecipeBookmarkModel.fromEntity(
    RecipeEntity recipe,
  ) {
    return RecipeBookmarkModel(
      id: recipe.id,
      title: recipe.title,
      image: recipe.image,
      category: recipe.category,
      ingredients: recipe.ingredients,
      instructions: recipe.instructions,
    );
  }

  RecipeEntity toEntity() {
    return RecipeEntity(
      id: id,
      title: title,
      image: image,
      category: category,
      instructions: instructions,
      ingredients: ingredients,
    );
  }
}