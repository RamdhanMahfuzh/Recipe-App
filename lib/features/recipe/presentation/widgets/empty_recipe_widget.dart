import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipe_app/features/recipe/presentation/bloc/recipe_bloc.dart';

class EmptyRecipeWidget extends StatelessWidget {
  const EmptyRecipeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: SvgPicture.asset('images/notfound.svg', fit: BoxFit.contain),
          ),
          const SizedBox(height: 20),
          Text(
            'Recipe not found',

            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try another keyword',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: MediaQuery.of(context).size.width * 0.03,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.055,

            child: ElevatedButton.icon(
              onPressed: () {
                context.read<RecipeBloc>().add(OnGetRecipes(''));
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              // icon: Icon(
              //   Icons.refresh,
              //   size: MediaQuery.of(context).size.width * 0.045,
              // ),
              label: Text(
                "See All Recipes",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.032,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
