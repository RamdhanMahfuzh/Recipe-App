import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/injection.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_detail_bloc.dart';
import 'package:shimmer/shimmer.dart';

class DetailPage extends StatelessWidget {
  final String id;

  const DetailPage({super.key, required this.id});

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
        // IMAGE SHIMMER (SliverAppBar replacement)
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

                // ingredients shimmer
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RecipeDetailBloc>()..add(OnGetRecipeDetail(id)),

      child: Scaffold(
        body: BlocBuilder<RecipeDetailBloc, RecipeDetailState>(
          builder: (context, state) {
            // ================= LOADING =================
            if (state is RecipeDetailLoading) {
              return _shimmerDetail();
            }

            // ================= LOADED =================
            if (state is RecipeDetailLoaded) {
              final recipe = state.recipe;

              return CustomScrollView(
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
                      background: Image.network(
                        recipe.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
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
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
