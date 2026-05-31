import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';
import 'package:recipe_app/features/recipe/domain/usecases/recipes/get_recipes.dart';
import 'package:recipe_app/features/recipe/domain/usecases/recipes/get_recipe_by_category.dart';
part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final GetRecipes getRecipes;
  final GetRecipeByCategory getRecipeByCategory;
  RecipeBloc(this.getRecipes, this.getRecipeByCategory)
    : super(RecipeInitial()) {
    on<OnGetRecipes>((event, emit) async {
      // TODO: implement event handler

      emit(RecipeLoading());

      try {
        final recipes = await getRecipes(event.query);
        emit(RecipeLoaded(recipes, 'All'));
      } catch (e) {
        emit(RecipeError(e.toString()));
      }
    });
    on<OnSelectCategory>((event, emit) async {
      emit(RecipeLoading());

      try {
        if (event.category == 'All') {
          add(OnGetRecipes(''));

          return;
        }

        final recipes = await getRecipeByCategory(event.category);

        emit(RecipeLoaded(recipes, event.category));
      } catch (e) {
        emit(RecipeError(e.toString()));
      }
    });
  }
}
