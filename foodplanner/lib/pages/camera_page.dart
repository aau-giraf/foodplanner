import 'dart:io' show File;
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/custom_square_camera_overlay.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import 'package:foodplanner/config/colors.dart';

/// This class is used to set up the in-app camera, to allow users to use their device's cameras.
class CameraPage extends StatefulWidget {
  final CameraController? controller; // Optional controller for managing the camera.
  final ImagePicker? imagePicker; // Optional image picker for selecting images.
  final ValueSetter onImagePicked;

  const CameraPage({
    super.key, // Key for the widget, used for maintaining state.
    this.controller, // Assign provided camera controller, if any.
    this.imagePicker, // Assign provided image picker, if any.
    required this.onImagePicked,
  });

  static const String routeName = '/camera_page'; // Route name for navigation to this page.

  @override
  State<CameraPage> createState() => _MealPageState(); // Creates the state object for this widget.
}

/// The state object which builds child widgets.
/// Binding observer notifies object of changes in the environment.
class _MealPageState extends State<CameraPage> with WidgetsBindingObserver {
  List<CameraDescription> cameras = []; // List for containing the available cameras of the device.
  CameraController? cameraController; // Controller for managing the camera.
  ImagePicker? imagePicker; // ImagePicker instance for selecting images.
  File? image; // The selected image's file.
  Uint8List? webImageBytes; // Used to store the image bytes for web

  /// A method for checking whether the app becomes inactive.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state); // Call the superclass method.
    if (cameraController == null || cameraController?.value.isInitialized == false) { // Checks if camera controller is null or not initialized.
      return; // Exit the method if camera is not initialized.
    }
    if (state == AppLifecycleState.inactive) { // Checks if the app is inactive.
      cameraController?.dispose(); // Deletes the camera controller.
    } else if (state == AppLifecycleState.resumed) { // Checks if the app becomes active.
      _setupCameraController(); // Sets up the camera controller.
    }
  }

  @override
  void initState() {
    super.initState(); // Call the superclass's initState method.
    if (widget.controller != null) { // Check if a camera controller is provided.
      cameraController = widget.controller; // Use the provided camera controller.
      imagePicker = widget.imagePicker ?? ImagePicker(); // Use provided image picker or create a new one.
    } else {
      _setupCameraController(); // Set up the camera controller if none is provided.
      imagePicker = ImagePicker(); // Set up a new image picker.
    }
  }

  /// The method which contains all the UI widgets, and forms them into the front end.
  @override
  Widget build(BuildContext context) {
    if (cameraController == null || cameraController?.value.isInitialized == false) { // Check if the camera controller is null or not initialized.
      return const Center(child: CircularProgressIndicator()); // Center widget to show loading indicator if camera is not ready.
    }

    // Scaffold is a layout structure from the flutter library for the UI.
    return Scaffold(
      body: image == null && webImageBytes == null
          ? SafeArea( // Ensures content is within the safe areas of the device.
              child: Stack( // Creates a stack layout widget.
                children: [
                  Positioned.fill(
                    child: AspectRatio( // Defining the aspect ratio of the widget.
                      aspectRatio: cameraController!.value.aspectRatio, // Sets the aspect ratio to match the camera controller.
                      child: CameraPreview(cameraController!), // Displays the camera preview.
                    ),
                  ),
                  // Positioned.fill(
                  //   child: CustomPaint(
                  //     painter: CustomSquareCameraOverlay(),
                  //   ),
                  // ),
                  Align( // Allows its widgets to be alligned.
                    alignment: Alignment.bottomCenter, // Alligns the widgets to the bottom center of the screen.
                    child: _controlPanel(context), // The control panel which contains the buttons.
                  ),
                ],
              ),
            )
          : _acceptImage(context),  
    );
  }

  /// The method which 
  Widget _acceptImage(BuildContext context) {
    final displayImage = kIsWeb
        ? Image.memory(webImageBytes!) // Display image as bytes for web
        : Image.file(image!); // Display image as a file for mobile

    return Container(
      child: Center( // Alligns the widget to the center.
        child: Column( // Vertical layout for the body.
          children: [
            Spacer(), // Creates an empty space.
            Container( // Container used for determining the size of the display image.
              width: MediaQuery.sizeOf(context).width > MediaQuery.sizeOf(context).height // Checks if the width is larger than the height of the device. This is done to create the smallest square for the display.
                  ? MediaQuery.sizeOf(context).height // If so, sets the width as the height of the device.
                  : MediaQuery.sizeOf(context).width, // If not, sets the width as the width of the device.
              height: MediaQuery.sizeOf(context).width > MediaQuery.sizeOf(context).height // Checks if the height is larger than the width of the device. This is done to create the smallest square for the display.
                  ? MediaQuery.sizeOf(context).height // If so, sets the height as the width of the device.
                  : MediaQuery.sizeOf(context).width, // If not, sets the height as the height of the device.
              decoration: BoxDecoration( // Used for changing the appearance of the display image.
                borderRadius: BorderRadius.circular(20), // Determines the rounded corner of the rectangle should have a radius of 20.
              ),
              child: displayImage, // Creates the widget for the display image.
            ),
            Row( // Horizontal layout for the body.
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Spaces the layout evenly 
              children: [
                Expanded( // Fills the available space of the row.
                  child: CustomButton( // Creates a custom made button for using the displayed image.
                    onTab: () { // When clicked, uses the picked image.
                      setState(() {
                        widget.onImagePicked(image ?? webImageBytes); // Sets the picked image to be the image selected image.
                      });
                    },
                    text: 'Anvend billede', // Text that is displayed on the button.
                  ),
                ),
                Expanded( // Fills the available space.
                  child: CustomButton( // Creates a custom button for cancelling the image selection.
                    onTab: () { // When clicked, sets the body back to the camera controller for taking another picture.
                      setState(() { // Updates the state of the page.
                        image = null; // Sets the selected image as null.
                        webImageBytes = null; // Sets the selected image as bytes to null.
                        _setupCameraController(); // Sets up the camera controller.
                      });
                    },
                    text: 'Fortryd', // Text that is displayed on the button.
                    backgroundColor: AppColors.secondary, // The background color of the button.
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  /// A method that contains the methods for creating the 2 buttons for the camera.
  Widget _controlPanel(BuildContext context) {
    return Container(
      height: 120, // Fixed height for the control panel.
      padding: const EdgeInsets.all(15), // Insets the buttens 15 pixels from the edge of the screen.
      child: Row( // Horizontal layout for the control buttons.
        mainAxisAlignment: MainAxisAlignment.start, // Aligns buttons to the start of the row.
        children: <Widget>[
          Flexible(child: _galleryControlWidget(context)), // Button to access the image gallery.
          Flexible(child: _cameraControlWidget(context)), // Button to take a picture with the camera.
          Spacer(), // Creates some space between the former and next widgets.
        ],
      ),
    );
  }

  /// The method which creates the button for opening the gallery through the camera.
  Widget _galleryControlWidget(context) {
    return Align( // Allows the widget to be alligned.
      alignment: Alignment.centerLeft, // Aligns button to the center left.
      child: Row( // Horizontal layout for the buttons.
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly spaces the buttons.
        mainAxisSize: MainAxisSize.min, // Allows the row to take up minimal width.
        children: <Widget>[
          FloatingActionButton( // Button for opening the gallery.
            backgroundColor: AppColors.secondary, // Sets background color for the button.
            onPressed: () { // Callback for when the button is pressed.
              _pickImageFromGallery(); // Calls function to pick an image from the gallery.
            },
            shape: RoundedRectangleBorder( // Sets the shape of the button to be a rounded rectangle.
              borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height), // Determines how rounded the corner of the rectangle should be.
            ),
            child: const Icon( // Icon displayed on the button.
              Icons.collections, // Collections icon for gallery access.
              color: AppColors.background, // Sets the color of the icon.
            ),
          )
        ],
      ),
    );
  }

  /// The method which creates the button for taking a picture.
  Widget _cameraControlWidget(BuildContext context) {
    return Align( // Centers the button within the expanded widget.
      alignment: Alignment.center, // Aligns the button to the center.
      child: SingleChildScrollView( // Creates a box which is scrollable.
        scrollDirection: Axis.horizontal, // Makes the box scroll horizontally.
        child: Row( // Horizontal layout for the buttons within the control panel.
          mainAxisAlignment: MainAxisAlignment.center, // Aligns horizontally to the center.
          children: <Widget>[
            FloatingActionButton( // Represents the button to take a picture.
              backgroundColor: AppColors.primary, // Sets the background color for the button.
              onPressed: () async { // Asynchronous callback when button is pressed.
                if (cameraController == null || !cameraController!.value.isInitialized) { // Checks if the camera controller is null or not initialized.
                  return; // Exits the method.
                }

                try { // Tries to run the following code, and catches any errors that occurs.
                  final XFile picture = await cameraController!.takePicture(); // Makes the device take a picture.
                  if (kIsWeb) { // Checks if the application is run on the web.
                    webImageBytes = await picture.readAsBytes(); // Reads the picture as bytes.
                    await cropImageToSquare(webImageBytes!); // Crops the image into a square.
                  } else { // If the application is not run on the web.
                    image = File(picture.path); // Sets the selected image as the taken image.
                    await cropImageToSquare(image!); // Crops the image into a square.
                  }
                  setState(() {}); // Updates the state of the page.
                } catch (e) { // Catches any errors.
                  print("Error taking picture: $e");
                }
              },
              shape: RoundedRectangleBorder( // Sets the border to be a rounded rectangle.
                borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height), // Determines how rounded the corner of the rectangle should be.
              ),
              child: const Icon( // Icon displayed on the FloatingActionButton.
                Icons.camera, // Camera icon for the button.
                color: AppColors.background, // Sets the color of the icon.
                size: 24, // Sets the size of the icon.
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A method for cropping the inputted image's size.
  Future<void> cropImageToSquare(dynamic inputImage) async {
    final img.Image? decodedImage; // The variable which will store the decoded image.
    if (inputImage is File) { // Checks if the image is in file form. If it is, the application is an app.
      decodedImage = img.decodeImage(await inputImage.readAsBytes()); // Decodes the image from the picture as bytes.
    } else if (inputImage is Uint8List) { // Checks if the image is an unsigned int. If it is, the application is a web application.
      decodedImage = img.decodeImage(inputImage); // Decodes the image.
    } else { // If none of the above, the image is an invalid type.
      throw ArgumentError('Invalid image type'); // Throws an error message.
    }

    if (decodedImage != null) { // Checks that the decoded image is not null.
      final width = decodedImage.width; // Sets the width of the decoded image.
      final height = decodedImage.height; // Sets the height of the decoded image.
      final squareSize = width < height ? width : height; // Sets the size of the square to the smallest value of the width and height.
      final croppedImage = img.copyCrop( // Sets the cropped image variable to be a cropped copy of the image.
        decodedImage, // The decoded image.
        (width - squareSize) ~/ 2, // Subtracts the square size from the width.
        (height - squareSize) ~/ 2, // Subtracts the square size from the height.
        squareSize, // Sets the width of the cropped image as the square size.
        squareSize, // Sets the height of the cropped image as the square size.
      );
      final croppedBytes = img.encodeJpg(croppedImage); // Encoded the cropped image into JPEG format.

      setState(() { // Updates the state.
        if (kIsWeb) { // Checks if the application is run on the web.
          webImageBytes = Uint8List.fromList(croppedBytes); // Sets the image as bytes.
        } else {
          final tempPath = inputImage.path.replaceFirst('.jpg', '_cropped.jpg'); // Creates a temporary path for the inputted image.
          final croppedFile = File(tempPath); // Sets the image as the file from the temp path.
          croppedFile.writeAsBytesSync(croppedBytes); // Synchronously writes the cropped bytes into a file.
          image = croppedFile; // Sets the selected image as the cropped image file.
        }
      });
    }
  }

  /// The method which creates the button for opening the gallery through the camera.
  Future<void> _pickImageFromGallery() async {
    final returnedImage = await imagePicker!.pickImage(source: ImageSource.gallery); // Gets image from the gallery of the device.
    if (returnedImage != null) { // Checks if any image was returned.
      if (kIsWeb) { // Checks if the application is run on the web.
        webImageBytes = await returnedImage.readAsBytes(); // Reads the picture as bytes.
        await cropImageToSquare(webImageBytes!); // Crops the image into a square.
      } else { // If the application is not run on the web.
        image = File(returnedImage.path); // Sets the selected image as the taken image.
        await cropImageToSquare(image!); // Crops the image into a square.
      }
      setState(() {}); // Updates the state.
    }
  }

  /// The method which sets up the camera controller for using the device's cameras.
  Future<void> _setupCameraController() async {
    cameras = await availableCameras(); // Checks if the device has any available cameras
    if (cameras.isNotEmpty) { // Checks that the camera list contains a camera.
      setState(() { // Updates the state to uses the new camera controller.
        cameraController = CameraController(cameras.first, ResolutionPreset.high); // Creates a camera controller using the front camera and sets the resolution as 720p.
      });
      await cameraController?.initialize(); // Waits until the camera controller is initialized.
      if (mounted) setState(() {}); // Checks if the state is currently a part of a tree. If yes, it updates the state.
    }
  }
}