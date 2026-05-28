import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/features/recipe/domain/entities/recipe_entity.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/bookmark_bloc/bookmark_bloc.dart';
import 'package:recipe_app/injection.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_detail_bloc/recipe_detail_bloc.dart';
import 'package:shimmer/shimmer.dart';

class DetailPage extends StatelessWidget {
  final String? id;
  final RecipeEntity? recipe;

  const DetailPage({super.key, this.id, this.recipe});

  // ================= SHIMMER HELPERS =================

  Widget _shimmerBox({double? width, double? height, BorderRadius? radius}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _shimmerDetail() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: Colors.transparent,

          leading: const BackButton(color: Colors.white),

          flexibleSpace: FlexibleSpaceBar(
            background: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,

              highlightColor: Colors.grey.shade100,

              child: Container(color: Colors.white),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                _shimmerBox(height: 28, width: 200),

                const SizedBox(height: 14),

                _shimmerBox(
                  height: 30,
                  width: 120,
                  radius: BorderRadius.circular(20),
                ),

                const SizedBox(height: 24),

                _shimmerBox(height: 22, width: 150),

                const SizedBox(height: 12),

                Column(
                  children: List.generate(
                    5,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),

                      child: Row(
                        children: [
                          _shimmerBox(width: 8, height: 8),

                          const SizedBox(width: 10),

                          Expanded(child: _shimmerBox(height: 12)),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                _shimmerBox(height: 22, width: 160),

                const SizedBox(height: 12),

                _shimmerBox(
                  height: 180,
                  width: double.infinity,

                  radius: BorderRadius.circular(12),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ================= DETAIL UI =================

  Widget _buildDetailContent(BuildContext context, RecipeEntity recipe) {
    return BlocListener<BookmarkBloc, BookmarkState>(
      listener: (context, state) {
        if (state is BookmarkActionSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: state.isAdded ? Colors.green : Colors.black,

                duration: const Duration(seconds: 2),

                content: Row(
                  children: [
                    Icon(
                      state.isAdded ? Icons.check_circle : Icons.delete,

                      color: Colors.white,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        state.isAdded
                            ? "Recipe successfully bookmarked"
                            : "Recipe removed from bookmarks",
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },

      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,

              backgroundColor: Colors.transparent,

              leading: IconButton(
                onPressed: () {
                  context.pop();
                },

                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),

              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(recipe.image, fit: BoxFit.cover),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Expanded(
                          child: Text(
                            recipe.title,

                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        BlocBuilder<BookmarkBloc, BookmarkState>(
                          builder: (context, state) {
                            final bookmarks = state is BookmarkLoaded
                                ? state.bookmarks
                                : <RecipeEntity>[];

                            final isBookmarked = bookmarks.any(
                              (e) => e.id == recipe.id,
                            );

                            return IconButton(
                              onPressed: () {
                                context.read<BookmarkBloc>().add(
                                  OnToggleBookmark(recipe),
                                );
                              },

                              icon: Icon(
                                isBookmarked
                                    ? Icons.bookmark
                                    : Icons.bookmark_border,

                                color: isBookmarked
                                    ? Colors.orange
                                    : Colors.black,
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.orange,

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Text(
                        recipe.category,

                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Ingredients",

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...recipe.ingredients.map((ingredient) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),

                        child: Row(
                          children: [
                            const Icon(Icons.circle, size: 8),

                            const SizedBox(width: 10),

                            Expanded(child: Text(ingredient)),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 30),

                    const Text(
                      "Instructions",

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,

                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Text(
                        recipe.instructions,

                        style: const TextStyle(height: 1.7, fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ================= OFFLINE MODE =================

    if (recipe != null) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<BookmarkBloc>()..add(OnGetBookmarks()),
          ),
        ],

        child: _buildDetailContent(context, recipe!),
      );
    }

    // ================= ONLINE MODE =================

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<RecipeDetailBloc>()..add(OnGetRecipeDetail(id!)),
        ),

        BlocProvider(create: (_) => sl<BookmarkBloc>()..add(OnGetBookmarks())),
      ],

      child: Scaffold(
        body: BlocBuilder<RecipeDetailBloc, RecipeDetailState>(
          builder: (context, state) {
            if (state is RecipeDetailLoading) {
              return _shimmerDetail();
            }

            if (state is RecipeDetailLoaded) {
              return _buildDetailContent(context, state.recipe);
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
