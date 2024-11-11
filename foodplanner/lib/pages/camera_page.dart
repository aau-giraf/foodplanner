import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import 'package:foodplanner/config/colors.dart';

/// This class is used to set up the in-app camera, to allow users to use their device's cameras.
///
/// StatefulWidget is a widget that has mutable state. This allows the class to update.
class CameraPage extends StatefulWidget {
  final CameraController? controller; // Optional controller for managing the camera.
  final ImagePicker? imagePicker; // Optional image picker for selecting images.
  final ValueSetter onImagePicked;
  final Client client;

  const CameraPage({
    super.key, // Key for the widget, used for maintaining state.
    this.controller, // Assign provided camera controller, if any.
    this.imagePicker, // Assign provided image picker, if any.
    required this.onImagePicked,
    required this.client,
  });

  static const String routeName = '/camera_page'; // Route name for navigation to this page.

  @override
  State<CameraPage> createState() => _MealPageState(); // Creates the state object for this widget.
}

// The state object which builds child widgets.
// Binding observer notifies object of changes in the environment.
class _MealPageState extends State<CameraPage> with WidgetsBindingObserver {
  List<CameraDescription> cameras = []; // List for containing the available cameras of the device.
  CameraController? cameraController; // Controller for managing the camera.
  ImagePicker? imagePicker; // ImagePicker instance for selecting images.

  /// A method for checking whether the app becomes inactive.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state); // Call the superclass method.
    if (cameraController == null || // Check if camera controller is null or not initialized.
        cameraController?.value.isInitialized == false) {
      // Checks if the device does not contain any cameras
      return; // Exit the method if camera is not initialized.
    }

    if (state == AppLifecycleState.inactive) {
      // Checks if the app is inactive. If yes, it destroys the controller.
      cameraController?.dispose(); // Dispose of the camera controller when inactive.
    } else if (state == AppLifecycleState.resumed) {
      // If the app becomes active again, the controller is reconstructed.
      _SetupCameraController(); // Reinitialise the camera controller.
    }
  }

  @override
  void initState() {
    super.initState(); // Call the superclass's initState method.
    if (widget.controller != null) { // Check if a camera controller is provided.
      cameraController = widget.controller; // Use the provided camera controller.
      imagePicker = widget.imagePicker ?? ImagePicker();  // Use provided image picker or create a new one.
    } else {
      _SetupCameraController(); // Set up the camera controller if none is provided.
    }
  }

  /// The method which contains all the UI widgets, and forms them into the front end.
  @override
  Widget build(BuildContext context) {
    if (cameraController == null || // Check if the camera controller is null or not initialized.
        cameraController?.value.isInitialized == false) {
      // Checks if the controller is not initialized
      return const Center( // Center widget to show loading indicator if camera is not ready.
        child:
            CircularProgressIndicator(), // Creates a loading circle in the middle of the screen.
      );
    }
    // Scaffold is a layout structure from the flutter library for the UI.
    return Scaffold(
      body: Container( // Container to hold the camera preview and controls.
        child: SafeArea( // Ensures content is within the safe areas of the device.
          child: Column( // Vertical layout for the camera preview and control panel.
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Alligns the horizontal axis.
            children: <Widget>[
              Expanded( // Expanded widget to take up available space.
                flex: 1, // Flex factor for the proportion of the space used.
                child: _cameraPreviewWidget(), // Displays the camera preview.
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
      height: 120, // Fixed height for the control panel.
      padding: const EdgeInsets.all(
          15), // Insets the buttens 15 pixels from the edge of the screen.
      child: Row( // Horizontal layout for the control buttons.
        mainAxisAlignment: MainAxisAlignment.start,  // Aligns buttons to the start of the row.
        children: <Widget>[
          _galleryControlWidget(context), // Button to access the image gallery.
          _cameraControlWidget(context), // Button to take a picture with the camera.
        ],
      ),
    );
  }

  /// The method which sets up the camera preview, which allows the user to see what the camera sees.
  Widget _cameraPreviewWidget() {
    return AspectRatio( // Ensures the aspect ratio of the camera preview matches the camera's.
      aspectRatio: cameraController!.value.aspectRatio, // Uses the camera's aspect ratio.
      child: CameraPreview(
          cameraController!), // Sets up the camera controller for the device's cameras.
    );
  }

  /// The method which creates the button for taking a picture.
  Widget _cameraControlWidget(context) {
    return Expanded(
      child: Align( // Centers the button within the expanded widget.
        alignment: Alignment.center,  // Aligns the button to the center.
        child: Row( // Horizontal layout for the buttons within the control panel.
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly spaces the buttons.
          mainAxisSize: MainAxisSize.max, // Allows the row to take up maximum width.
          children: <Widget>[
            FloatingActionButton( // Represents the button to take a picture.
                backgroundColor: AppColors.background, // Sets the background color for the button.
                onPressed: () async { // Asynchronous callback when button is pressed.
                  // Awaits for the button to be pressed.
                  XFile picture = await cameraController!.takePicture(); // Makes the device take a picture.
                  // Gal.putImage(picture.path);// Saves the new picture in the device's gallery app.
                  widget.onImagePicked(picture);
                },
                child: const Icon( // Icon displayed on the FloatingActionButton.
                  Icons.camera, // Camera icon for the button.
                  color: AppColors.primary, // Sets the color of the icon.
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
      child: Align( // Aligns the button to the left side.
        alignment: Alignment.centerLeft, // Aligns button to the center left.
        child: Row( // Horizontal layout for the buttons.
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly spaces the buttons.
          mainAxisSize: MainAxisSize.max, // Allows the row to take up maximum width.
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: AppColors.background, // Sets background color for the button.
              onPressed: () { // Callback for when the button is pressed.
                _pickImageFromGallery(); // Calls function to pick an image from the gallery.
              },
              child: const Icon( // Icon displayed on the button.
                Icons.collections, // Collections icon for gallery access.
                color: AppColors.secondary, // Sets the color of the icon.
              ),
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
        cameras = cameras; // Updates the cameras variable with available 
        cameraController = CameraController(
          cameras.first, // Uses the front facing camera.
          ResolutionPreset.high, // Sets the resolution of the camera as 720p.
        );
      });
      cameraController?.initialize().then((_) {
        // Initializes the camera and then rebuilds the widget tree to make the camera appear on the UI.
        if (!mounted) {
          // Checks if the state is not currently a part of a tree.
          return; // Exit if the widget is no longer part of the tree.
        }
        setState(() {}); // Trigger a rebuild after the camera initialization completes.
      }).catchError((Object e) { // Catches any errors during initialization.
        if (kDebugMode) { // Check if in debug mode.
          print(e); // Print the error message to the console for debugging.
        }
      });
    }
  }

  /// The method which allows the user to select an image from the gallery app.
  Future _pickImageFromGallery() async {
    final returnedImage =
        await imagePicker!.pickImage(source: ImageSource.gallery);  // Opens gallery and waits for image selection.
    if (returnedImage != null) {  // Check if an image was actually selected.
      // Check if an image was actually selected
      setState(() { // Update the state with the newly selected image.
        widget.onImagePicked(returnedImage);
      });
    } else {
      // Handle the case when no image is selected (optional)
      if (kDebugMode) { // Check if in debug mode.
        print("Intet billede valgt."); // Print a message indicating no image was selected.
      }
    }
  }
}