import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipe/presentation/pages/recipe_page.dart';
import 'package:recipe_app/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      home: const RecipePage(),
    );
  }
}
