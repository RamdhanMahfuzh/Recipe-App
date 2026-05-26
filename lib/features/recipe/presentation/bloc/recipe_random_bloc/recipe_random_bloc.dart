import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';
import 'package:recipe_app/features/recipe/domain/usecases/recipes/get_recipe_random.dart';

part 'recipe_random_event.dart';
part 'recipe_random_state.dart';

class RandomRecipeBloc extends Bloc<RandomRecipeEvent, RandomRecipeState> {
  final GetRandomRecipe getRandomRecipe;

  RandomRecipeBloc(this.getRandomRecipe)
      : super(RandomRecipeInitial()) {
    on<OnGetRandomRecipe>((event, emit) async {
      emit(RandomRecipeLoading());

      try {
        final result = await getRandomRecipe();
        emit(RandomRecipeLoaded(result));
      } catch (e) {
        emit(RandomRecipeError(e.toString()));
      }
    });
  }
}