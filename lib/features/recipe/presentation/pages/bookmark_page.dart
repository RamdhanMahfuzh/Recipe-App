import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:recipe_app/features/recipe/presentation/pages/detail_page.dart';
import 'package:recipe_app/injection.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookmarkBloc>()..add(OnGetBookmarks()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Bookmarks",
                style: TextStyle(color: Colors.white),
              ),

              backgroundColor: Colors.orange,

              actions: [
                IconButton(
                  onPressed: () {
                    final rootContext = context;
                    rootContext.read<BookmarkBloc>().add(
                      OnSelectAllBookmarks(),
                    );
                  },

                  icon: const Icon(Icons.select_all),
                ),

                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,

                      builder: (_) {
                        return AlertDialog(
                          title: const Text("Delete Selected"),

                          content: const Text("Delete selected bookmarks?"),

                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },

                              child: const Text("Cancel"),
                            ),

                            ElevatedButton(
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

            body: BlocBuilder<BookmarkBloc, BookmarkState>(
              builder: (context, state) {
                if (state is BookmarkLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is BookmarkLoaded) {
                  if (state.bookmarks.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            size: 80,
                            color: Colors.grey,
                          ),

                          SizedBox(height: 12),

                          Text(
                            "No Recipe Save",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.bookmarks.length,

                    itemBuilder: (context, index) {
                      final recipe = state.bookmarks[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),

                        child: ListTile(
                          onTap: () {
                            // context.push('/detail/${recipe.id}');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(recipe: recipe),
                              ),
                            );
                          },

                          contentPadding: const EdgeInsets.all(10),

                          leading: Checkbox(
                            value: state.selectedIds.contains(recipe.id),

                            onChanged: (_) {
                              context.read<BookmarkBloc>().add(
                                OnToggleSelectBookmark(recipe.id),
                              );
                            },
                          ),

                          title: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),

                                child: Image.network(
                                  recipe.image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      recipe.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    Text(recipe.category),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // subtitle: Text(recipe.category),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertDialog(
                                    title: const Text("Remove Bookmark"),

                                    content: Text("Remove ${recipe.title} ?"),

                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(dialogContext);
                                        },

                                        child: const Text("Cancel"),
                                      ),

                                      ElevatedButton(
                                        onPressed: () {
                                          context.read<BookmarkBloc>().add(
                                            OnToggleBookmark(recipe),
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

                            icon: const Icon(Icons.close, color: Colors.red),
                          ),
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          );
        },
      ),
    );
  }
}
