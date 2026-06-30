import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_app/core/theme/app_theme.dart';

import 'package:recipe_app/features/recipe/presentation/bloc/recipe_bloc/recipe_bloc.dart';

class EmptyRecipeWidget extends StatelessWidget {
  const EmptyRecipeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.26,
              child: SvgPicture.asset(
                'assets/images/notfound.svg',
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),
            Text(
              'Recipe not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Try another keyword',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  context.read<RecipeBloc>().add(OnGetRecipes(''));
                },
                child: const Text("See all recipes"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
