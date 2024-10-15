import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';

import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/config/colors.dart';

/// This class is used to set up the in-app camera, to allow users to use their device's cameras.
///
/// StatefulWidget is a widget that has mutable state. This allows the class to update.
class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _MealPageState();
}

// The state object which builds child widgets.
// Binding observer notifies object of changes in the environment.
class _MealPageState extends State<CameraPage> with WidgetsBindingObserver {
  List<CameraDescription> cameras =
      []; // List for containing the available cameras of the device.
  CameraController? cameraController;

  File? _selectedImage;

  /// A method for checking whether the app becomes inactive.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      // Checks if the device does not contain any cameras
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

  /// The method which contains all the UI widgets, and forms them into the front end.
  @override
  Widget build(BuildContext context) {
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      // Checks if the controller is not initialized
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
              _controlPanel(
                  context), // The control panel which contains the buttons.
            ],
          ),
        ),
      ),
    );
  }

  /// A method that contains the methods for creating the 3 buttons for the camera.
  Widget _controlPanel(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(
          15), // Insets the buttens 15 pixels from the edge of the screen.
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

  /// The method which sets up the camera preview, which allows the user to see what the camera sees.
  Widget _cameraPreviewWidget() {
    return AspectRatio(
      aspectRatio: cameraController!.value.aspectRatio,
      child: CameraPreview(
          cameraController!), // Sets up the camera controller for the device's cameras.
    );
  }

  /// The method which creates the button for taking a picture.
  Widget _cameraControlWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
                backgroundColor: AppColors.background,
                onPressed: () async {
                  // Awaits for the button to be pressed.
                  XFile picture = await cameraController!
                      .takePicture(); // Makes the device take a picture.
                  Gal.putImage(
                    // Saves the new picture in the device's gallery app.
                    picture.path,
                  );
                },
                child: const Icon(
                  Icons.camera,
                  color: AppColors.primary,
                  // color: Color.fromARGB(255, 244, 168, 54),
                ))
          ],
        ),
      ),
    );
  }

  /// The method which creates the button for opening the gallery through the camera.
  Widget _galleryControlWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: AppColors.background,
              onPressed: () {
                _pickImageFromGallery();
              },
              child: const Icon(
                Icons.collections,
                color: AppColors.secondary,
              ),
            )
          ],
        ),
      ),
    );
  }

  ///           !!! Old method which is no longer needed !!!
  Widget _navigateButton(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: AppColors.secondary,
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) =>
                //           const AlternateMealpage()
                //   ), // Naviger til den nye side
                // );
              },
              child:
                  const Icon(Icons.arrow_forward, color: AppColors.background),
            )
          ],
        ),
      ),
    );
  }

  /// The method which sets up the camera controller for using the device's cameras.
  Future<void> _SetupCameraController() async {
    List<CameraDescription> cameras =
        await availableCameras(); // Checks if the device has any available cameras
    if (cameras.isNotEmpty) {
      setState(() {
        cameras = cameras;
        cameraController = CameraController(
          cameras.first, // Uses the front facing camera.
          ResolutionPreset.high, // Sets the resolution of the camera as 720p.
        );
      });
      cameraController?.initialize().then((_) {
        // Initializes the camera and then rebuilds the widget tree to make the camera appear on the UI.
        if (!mounted) {
          // Checks if the state is not currently a part of a tree.
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (kDebugMode) {
          print(e);
        }
      });
    }
  }

  /// The method which allows the user to select an image from the gallery app.
  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage != null) {
      // Check if an image was actually selected
      setState(() {
        _selectedImage = File(returnedImage.path);
      });
    } else {
      // Handle the case when no image is selected (optional)
      if (kDebugMode) {
        print("Intet billede valgt.");
      }
    }
  }
}
