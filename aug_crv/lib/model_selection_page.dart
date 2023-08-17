import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelSelectionPage extends StatelessWidget {
  final List<String> availableModels = ["Chicken_01.glb", "Duck.glb"];

  ModelSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Model'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
        ),
        itemCount: availableModels.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3, // Add elevation for a card-like effect
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ModelViewer(
                    backgroundColor:
                        const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
                    src: 'assets/models/${availableModels[index]}',
                    alt: 'A 3D model',
                    ar: false,
                    autoRotate: true,
                    cameraControls: true,
                    iosSrc: 'assets/models/${availableModels[index]}',
                    disableZoom: false,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, availableModels[index]);
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 2.0, color: Colors.blue),
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: const Center(
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
