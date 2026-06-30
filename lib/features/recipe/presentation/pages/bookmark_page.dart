import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/theme/app_theme.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:recipe_app/features/recipe/presentation/pages/detail_page.dart';
import 'package:recipe_app/injection.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

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
                title: const Text("Bookmarks"),

                actions: [
                  IconButton(
                    onPressed: isEmpty
                        ? null
                        : () {
                            context.read<BookmarkBloc>().add(
                              OnSelectAllBookmarks(),
                            );
                          },

                    icon: const Icon(Icons.select_all),
                  ),

                  IconButton(
                    onPressed: isEmpty || isNoSelection
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text("Delete Selected"),

                                  content: const Text(
                                    "Delete selected bookmarks?",
                                  ),

                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },

                                      child: const Text("Cancel"),
                                    ),

                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.danger,
                                      ),
                                      onPressed: () {
                                        context.read<BookmarkBloc>().add(
                                          OnDeleteSelectedBookmarks(),
                                        );

                                        Navigator.pop(context);
                                      },

                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },

                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),

              body: isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          const Icon(
                            Icons.bookmark_border,
                            size: 72,
                            color: AppColors.textMuted,
                          ),

                          const SizedBox(height: AppSpacing.md),

                          Text(
                            "No recipe saved",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            "Bookmarked recipes will appear here",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),

                      itemCount: state.bookmarks.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),

                      itemBuilder: (context, index) {
                        final recipe = state.bookmarks[index];

                        return Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(
                              AppRadius.md,
                            ),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) => DetailPage(recipe: recipe),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(
                              AppRadius.md,
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: state.selectedIds.contains(
                                    recipe.id,
                                  ),

                                  onChanged: (_) {
                                    context.read<BookmarkBloc>().add(
                                      OnToggleSelectBookmark(recipe.id),
                                    );
                                  },
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.sm,
                                  ),

                                  child: Image.network(
                                    recipe.image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(width: AppSpacing.md),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        recipe.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        recipe.category,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,

                                      builder: (dialogContext) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Remove Bookmark",
                                          ),

                                          content: Text(
                                            "Remove ${recipe.title} ?",
                                          ),

                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(dialogContext);
                                              },

                                              child: const Text("Cancel"),
                                            ),

                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.danger,
                                              ),
                                              onPressed: () {
                                                context
                                                    .read<BookmarkBloc>()
                                                    .add(
                                                      OnToggleBookmark(
                                                        recipe,
                                                      ),
                                                    );

                                                Navigator.pop(dialogContext);
                                              },

                                              child: const Text("Remove"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },

                                  icon: const Icon(
                                    Icons.close,
                                    color: AppColors.danger,
                                  ),
                                ),
                              ],
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
