import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';
import 'package:recipe_app/features/recipe/domain/usecases/recipes/get_recipe_detail.dart';

part 'recipe_detail_event.dart';
part 'recipe_detail_state.dart';

class RecipeDetailBloc extends Bloc<RecipeDetailEvent, RecipeDetailState> {
  final GetRecipeDetail getRecipeDetail;

  RecipeDetailBloc(this.getRecipeDetail) : super(RecipeDetailInitial()) {
    on<OnGetRecipeDetail>((event, emit) async {
      emit(RecipeDetailLoading());

      try {
        final result = await getRecipeDetail(event.id);
        emit(RecipeDetailLoaded(result));
      } catch (e) {
        emit(RecipeDetailError(e.toString()));
      }
    });
  }
}
