part of 'bookmark_bloc.dart';

abstract class BookmarkEvent {}

class OnGetBookmarks extends BookmarkEvent {}

class OnToggleBookmark extends BookmarkEvent {
  final RecipeEntity recipe;

  OnToggleBookmark(this.recipe);
}

class OnToggleSelectBookmark extends BookmarkEvent {
  final String id;

  OnToggleSelectBookmark(this.id);
}

class OnSelectAllBookmarks extends BookmarkEvent {}

class OnDeleteSelectedBookmarks extends BookmarkEvent {}
