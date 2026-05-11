import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';
import 'package:recipe_app/features/recipe/domain/usecases/get_recipes.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final GetRecipes getRecipes;
  RecipeBloc(this.getRecipes) : super(RecipeInitial()) {
    on<OnGetRecipes>((event, emit) async {
      // TODO: implement event handler

      emit(RecipeLoading());

      try {
        final recipes = await getRecipes(event.query);
        emit(RecipeLoaded(recipes));
      } catch (e) {
        emit(RecipeError(e.toString()));
      }
    });
  }
}
