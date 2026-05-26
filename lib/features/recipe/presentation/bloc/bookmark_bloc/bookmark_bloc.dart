import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/features/recipe/data/models/recipe_bookmark_model.dart';
import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';
import 'package:recipe_app/features/recipe/domain/usecases/bookmarks.dart/get_bookmarks.dart';
import 'package:recipe_app/features/recipe/domain/usecases/bookmarks.dart/toggle_bookmark.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final GetBookmarks getBookmarks;
  final ToggleBookmark toggleBookmark;
  List<String> selectedIds = [];

  BookmarkBloc(this.getBookmarks, this.toggleBookmark)
    : super(BookmarkInitial()) {
    on<OnGetBookmarks>(_onGetBookmarks);

    on<OnToggleBookmark>(_onToggleBookmark);

    on<OnToggleSelectBookmark>(_onToggleSelectBookmark);

    on<OnSelectAllBookmarks>(_onSelectAllBookmarks);

    on<OnDeleteSelectedBookmarks>(_onDeleteSelectedBookmarks);
  }

  Future<void> _onGetBookmarks(
    OnGetBookmarks event,
    Emitter<BookmarkState> emit,
  ) async {
    emit(BookmarkLoading());

    final data = await getBookmarks();

    final bookmarks = data
        .map(
          (e) => RecipeEntity(
            id: e.id,
            title: e.title,
            image: e.image,
            category: e.category,
            instructions: e.instructions,
            ingredients: e.ingredients,
          ),
        )
        .toList();

    emit(BookmarkLoaded(bookmarks));
  }

  Future<void> _onToggleBookmark(
    OnToggleBookmark event,
    Emitter<BookmarkState> emit,
  ) async {
    print("TOGGLE: ${event.recipe.title}");
    final oldBookmarks = await getBookmarks();

    final isExist = oldBookmarks.any((e) => e.id == event.recipe.id);

    await toggleBookmark(RecipeBookmarkModel.fromEntity(event.recipe));

    final data = await getBookmarks();

    print("TOTAL BOOKMARK: ${data.length}");
    for (var item in data) {
      print(item.title);
    }
    emit(BookmarkActionSuccess(!isExist));

    add(OnGetBookmarks());
  }

  Future<void> _onSelectAllBookmarks(
    OnSelectAllBookmarks event,
    Emitter<BookmarkState> emit,
  ) async {
    final data = await getBookmarks();

    selectedIds = data.map((e) => e.id).toList();

    emit(
      BookmarkLoaded(
        data.map((e) => e.toEntity()).toList(),

        selectedIds: selectedIds,
      ),
    );
  }

  Future<void> _onDeleteSelectedBookmarks(
    OnDeleteSelectedBookmarks event,
    Emitter<BookmarkState> emit,
  ) async {
    final data = await getBookmarks();

    for (var item in data) {
      if (selectedIds.contains(item.id)) {
        await toggleBookmark(item);
      }
    }

    selectedIds = [];

    add(OnGetBookmarks());
  }

  Future<void> _onToggleSelectBookmark(
    OnToggleSelectBookmark event,
    Emitter<BookmarkState> emit,
  ) async {
    if (selectedIds.contains(event.id)) {
      selectedIds.remove(event.id);
    } else {
      selectedIds.add(event.id);
    }

    final data = await getBookmarks();

    emit(
      BookmarkLoaded(
        data.map((e) => e.toEntity()).toList(),

        selectedIds: selectedIds,
      ),
    );
  }
}
