import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'alternateMealPage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';

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

  File? _selectedImage;

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
    // Checks if the controller is not initialized
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const Center(
        child:
            CircularProgressIndicator(), // Creates a loading circle in the middle of the screen.
      );
    }
    // Scaffold is a layout structure from the flutter library for the UI.
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Alligns the horizontal axis.
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _cameraPreviewWidget(),
              ),
              _controlPanel(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _controlPanel(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _galleryControlWidget(context),
          _cameraControlWidget(context),
          _navigateButton(context),
        ],
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    return AspectRatio(
      aspectRatio: cameraController!.value.aspectRatio,
      child: CameraPreview(cameraController!),
    );
  }

  Widget _cameraControlWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
                child: Icon(
                  Icons.camera,
                  color: Color.fromARGB(255, 244, 168, 54),
                ),
                backgroundColor: Colors.white,
                onPressed: () async {
                  XFile picture = await cameraController!.takePicture();
                  Gal.putImage(
                    picture.path,
                  );
                })
          ],
        ),
      ),
    );
  }

  Widget _galleryControlWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(
                Icons.collections,
                color: Color.fromARGB(255, 123, 116, 242),
              ),
              backgroundColor: Colors.white,
              onPressed: () {
                _pickImageFromGallery();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _navigateButton(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              child: const Icon(Icons.arrow_forward, color: Colors.white),
              backgroundColor: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const AlternateMealpage()), // Naviger til den nye side
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _SetupCameraController() async {
    // Checks if the device has any available cameras
    List<CameraDescription> cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        cameras = cameras;
        cameraController = CameraController(
          cameras.first, // Uses the front facing camera.
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

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    // Check if an image was actually selected
    if (returnedImage != null) {
      setState(() {
        _selectedImage = File(returnedImage.path);
      });
    } else {
      // Handle the case when no image is selected (optional)
      print("No image selected.");
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error:${e.code}\nError message : ${e.description}';
    print(errorText);
  }
}
