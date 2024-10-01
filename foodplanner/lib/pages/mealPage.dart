import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gal/gal.dart';

//StatefulWidget is a widget that has mutable state. This allows the class to update.
class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

// The state object which builds child widgets.
// Binding observer notifies object of changes in the environment.
class _MealPageState extends State<MealPage> with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Checks if the app is inactive. If yes, it destroys the controller.
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // If the app becomes active again, the controller is reconstructed.
      _SetupCameraController();
    }
  }

  @override
  void initState() {
    super.initState();
    _SetupCameraController();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout structure from the flutter library for the UI.
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    // Checks if the controller is not initialized
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const Center(
        child:
            CircularProgressIndicator(), // Creates a loading circle in the middle of the screen.
      );
    }
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Alligns the vertical axis.
          crossAxisAlignment:
              CrossAxisAlignment.center, // Alligns the horizontal axis.
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.3,
              width: MediaQuery.sizeOf(context).width * 0.8,
              child: CameraPreview(
                cameraController!,
              ),
            ),
            IconButton(
              onPressed: () async {
                XFile picture = await cameraController!.takePicture();
                Gal.putImage(
                  picture.path,
                );
              },
              iconSize: 100,
              icon: const Icon(
                Icons.camera,
                color: Color.fromARGB(255, 244, 168, 54),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _SetupCameraController() async {
    // Checks if the device has any available cameras
    List<CameraDescription> _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      setState(() {
        cameras = _cameras;
        cameraController = CameraController(
          _cameras.first, // Uses the front facing camera.
          ResolutionPreset.high, // Sets the resolution of the camera as 720p.
        );
      });
      // Initializes the camera and then rebuilds the widget tree to make the camera appear on the UI.
      cameraController?.initialize().then((_) {
        // Checks if the state is not currently a part of a tree.
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        print(e);
      });
    }
  }
}