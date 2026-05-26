import 'package:flutter/material.dart';
import 'package:recipe_app/core/router/app_router.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:recipe_app/features/recipe/data/models/recipe_bookmark_model.dart';
import 'package:recipe_app/injection.dart';
import 'package:recipe_app/test_hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(RecipeBookmarkModelAdapter());

  await Hive.openBox<RecipeBookmarkModel>('bookmarks');

  // testHive();

  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
