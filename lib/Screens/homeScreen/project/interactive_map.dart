import 'package:app/Screens/homeScreen/project/bed_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InteractiveMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gridStateBox = Hive.box<GridStateModel>('gridStates');

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
            ],
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: gridStateBox.listenable(),
          builder: (context, Box<GridStateModel> box, _) {
            return Center(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 16,
                itemBuilder: (context, index) {
                  final gridState = box.get(index) ??
                      GridStateModel(
                        gridIndex: index,
                        isPlanted: false,
                        lastUpdated: DateTime.now(),
                      );

                  return GestureDetector(
                    onTap: () async {
                      gridState.isPlanted = !gridState.isPlanted;
                      gridState.lastUpdated = DateTime.now();
                      await box.put(index, gridState);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Grid ${index + 1} ${gridState.isPlanted ? 'planted' : 'unplanted'}",
                          ),
                        ),
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
                          gridState.isPlanted
                              ? 'assets/images/siembra.png'
                              : 'assets/images/vasito.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
