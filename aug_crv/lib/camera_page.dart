import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:aug_crv/model_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isRearCameraSelected = true;
  ARSessionManager? _arSessionManager;
  ARNode? webObjectNode;
  ARNode? localObjectNode;
  ARObjectManager? _arObjectManager;

  @override
  void dispose() {
    super.dispose();
    _arSessionManager!.dispose();
  }

  void onARViewCreated(
      arSessionManager, arObjectManager, arAnchorManager, arLocationManager) {
    arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "triangle.png",
      showWorldOrigin: true,
      handleTaps: false,
    );

    _arSessionManager = arSessionManager;
    _arObjectManager = arObjectManager;

    arObjectManager.onInitialize();
  }

  Future<void> takeScreenshot() async {
    var image = await _arSessionManager!.snapshot();
    if (context.mounted) {
      await showDialog(
          context: context,
          builder: (_) => Dialog(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(image: image, fit: BoxFit.cover)),
                ),
              ));
    }
  }

  Future<void> onLocalObjectButtonPressed(model) async {
    // 1
    if (localObjectNode != null) {
      _arObjectManager?.removeNode(localObjectNode!);
      localObjectNode = null;
    } else {
      // 2
      var newNode = ARNode(
          type: NodeType.localGLTF2,
          uri: 'assets/models/$model',
          scale: vector_math.Vector3(0.2, 0.2, 0.2),
          position: vector_math.Vector3(0.0, 0.0, 0.0),
          rotation: vector_math.Vector4(1.0, 0.0, 0.0, 0.0));
      // 3
      bool? didAddLocalNode = await _arObjectManager?.addNode(newNode);
      localObjectNode = (didAddLocalNode!) ? newNode : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Scene'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // AR View
            ARView(
              onARViewCreated: (arSessionManager, arObjectManager,
                  arAnchorManager, arLocationManager) {
                // Set up the AR controller
                onARViewCreated(arSessionManager, arObjectManager,
                    arAnchorManager, arLocationManager);
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                    color: Colors.black),
                // AR controls
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 30,
                        icon: Icon(
                          _isRearCameraSelected
                              ? Icons.switch_camera
                              : Icons.switch_camera_sharp,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() =>
                              _isRearCameraSelected = !_isRearCameraSelected);
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          // Call the function to take an AR screenshot
                          takeScreenshot();
                        },
                        iconSize: 50,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.circle, color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        // Navigate to the model selection page and wait for the user's selection
                        final selectedModel = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModelSelectionPage(),
                          ),
                        );

                        if (selectedModel != null) {
                          final selectedGLTFModel =
                              selectedModel.replaceAll(".glb", ".gltf");
                          onLocalObjectButtonPressed(selectedGLTFModel);
                        }
                      },
                      child: const Text('Select Model'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
