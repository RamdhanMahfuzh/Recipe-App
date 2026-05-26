import 'package:go_router/go_router.dart';
import 'package:recipe_app/features/recipe/presentation/pages/detail_page.dart';
import 'package:recipe_app/features/recipe/presentation/pages/recipe_page.dart';
import 'package:recipe_app/features/recipe/presentation/pages/bookmark_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const RecipePage();
      },
    ),

    GoRoute(
      path: '/detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;

        return DetailPage(id: id);
      },
    ),

    GoRoute(
      path: '/bookmark',
      builder: (context, state) {
        return const BookmarkPage();
      },
    ),
  ],
);
