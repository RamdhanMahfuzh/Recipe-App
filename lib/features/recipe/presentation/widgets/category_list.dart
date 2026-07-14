import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/core/theme/app_theme.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_bloc/recipe_bloc.dart';
import 'package:recipe_app/features/recipe/presentation/widgets/category_chip.dart';

const _categories = [
  'All',
  'Beef',
  'Chicken',
  'Seafood',
  'Vegetarian',
  'Side',
  'Pork',
  'Lamb',
  'Pasta',
  'Dessert',
  'Miscellaneous',
];

class CategoryList extends StatelessWidget {
  final String selectedCategory;

  const CategoryList({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'Category',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return CategoryChip(
                label: category,
                isSelected: selectedCategory == category,
                onTap: () {
                  context.read<RecipeBloc>().add(OnSelectCategory(category));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
