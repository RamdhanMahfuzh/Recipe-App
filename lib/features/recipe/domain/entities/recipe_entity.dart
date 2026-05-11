import 'package:equatable/equatable.dart';

class RecipeEntity extends Equatable {
  final String id;
  final String title;
  final String image;
  final String instructions;
  final String category;
  final List<String> ingredients;

 const RecipeEntity({
    required this.id,
    required this.title,
    required this.image,
    required this.instructions,
    required this.category,
    required this.ingredients,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    title,
    image,
    instructions,
    category,
    ingredients,
  ];
}
