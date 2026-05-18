import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OfflineRecipeWidget extends StatelessWidget {
  const OfflineRecipeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // IMAGE RESPONSIVE
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: SvgPicture.asset(
              'assets/images/offline.svg',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "You're in offline mode",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Try to connect internet",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.058,
            child: ElevatedButton.icon(
              onPressed: () {
                // nanti arahkan ke bookmark/saved page
                // context.push('/saved');
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              icon: Icon(
                Icons.bookmark,
                size: MediaQuery.of(context).size.width * 0.048,
              ),

              label: Text(
                "Go to Saved Recipe",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
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
