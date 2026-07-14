import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/theme/app_theme.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:recipe_app/features/recipe/presentation/pages/detail_page.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/bookmark_empty_state.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/bookmark_list_item.dart';
import 'package:recipe_app/injection.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Delete Selected'),
          content: const Text('Delete selected bookmarks?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
              ),
              onPressed: () {
                context.read<BookmarkBloc>().add(OnDeleteSelectedBookmarks());
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookmarkBloc>()..add(OnGetBookmarks()),
      child: BlocBuilder<BookmarkBloc, BookmarkState>(
        builder: (context, state) {
          if (state is BookmarkLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is BookmarkLoaded) {
            final isEmpty = state.bookmarks.isEmpty;
            final isNoSelection = state.selectedIds.isEmpty;

            return Scaffold(
              appBar: AppBar(
                title: const Text('Bookmarks'),
                actions: [
                  IconButton(
                    onPressed: isEmpty
                        ? null
                        : () => context.read<BookmarkBloc>().add(
                              OnSelectAllBookmarks(),
                            ),
                    icon: const Icon(Icons.select_all),
                  ),
                  IconButton(
                    onPressed: isEmpty || isNoSelection
                        ? null
                        : () => _showDeleteDialog(context),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              body: isEmpty
                  ? const BookmarkEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: state.bookmarks.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final recipe = state.bookmarks[index];
                        return BookmarkListItem(
                          recipe: recipe,
                          isSelected: state.selectedIds.contains(recipe.id),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(recipe: recipe),
                            ),
                          ),
                        );
                      },
                    ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
