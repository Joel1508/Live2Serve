import 'package:flutter/material.dart';

class InteractiveMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Interactive Hydroponic Map"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD7FBE8),
              Color(0xFFA7E2C7),
            ], // Gradient background
          ),
        ),
        child: Center(
          child: GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 4 columns
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 16, // Number of grid cells
            itemBuilder: (context, index) {
              bool isPlanted = index % 2 ==
                  0; // Example condition for planted/unplanted state
              return GestureDetector(
                onTap: () {
                  // Handle interaction
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Selected grid ${index + 1}")),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      isPlanted
                          ? 'assets/images/siembra.png' // Planted image
                          : 'assets/images/vasito.png', // Unplanted image
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
