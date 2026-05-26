part of 'bookmark_bloc.dart';

abstract class BookmarkState {}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoading extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final List<RecipeEntity> bookmarks;

  final List<String> selectedIds;

  BookmarkLoaded(this.bookmarks, {this.selectedIds = const []});
}

class BookmarkActionSuccess extends BookmarkState {
  final bool isAdded;

  BookmarkActionSuccess(this.isAdded);
}
