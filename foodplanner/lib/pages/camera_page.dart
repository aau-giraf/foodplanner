import 'dart:io' show File;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:http/http.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:foodplanner/config/text_styles.dart';
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

  @override
  State<CameraPage> createState() => _MealPageState(); // Creates the state object for this widget.
}

/// The state object which builds child widgets.
/// Binding observer notifies object of changes in the environment.
class _MealPageState extends State<CameraPage> with WidgetsBindingObserver {
  List<CameraDescription> cameras = []; // List for containing the available cameras of the device.
  CameraController? cameraController; // Controller for managing the camera.
  ImagePicker? imagePicker; // ImagePicker instance for selecting images.
  Uint8List? imageBytes; // The selected image's file.
  bool imagePicked = false;
  bool imageCropped = false;
  bool imageAccepted = false;

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

  /// The method which contains all the UI widgets, and forms them into the front end.
  @override
  Widget build(BuildContext context) {
    if (cameraController == null || cameraController?.value.isInitialized == false) { // Check if the camera controller is null or not initialized.
      return const Center(child: CircularProgressIndicator()); // Center widget to show loading indicator if camera is not ready.
    }

    // Scaffold is a layout structure from the flutter library for the UI.
    return Scaffold(
      body: imageBytes == null
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
                      child: _buttonPanel(context), // The control panel which contains the buttons.
                    ),
                  ],
                ),
              )
            : imagePicked
              ? CircularProgressIndicator()
              : _displayImage(context),
    );
  }

  /// Widget to display the selected image.
  Widget _displayImage(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width > MediaQuery.sizeOf(context).height
        ? MediaQuery.sizeOf(context).height
        : MediaQuery.sizeOf(context).width;

    return Container(
      child: Center(
        child: Column(
          children: [
            Spacer(),
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: imageBytes != null ? Image.memory(imageBytes!) : Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    onTab: () async {
                      setState(() {
                        imageAccepted = true; // Show loading state
                      });

                      // Call onImagePicked after the image is cropped
                      widget.onImagePicked(
                        http.MultipartFile.fromBytes(
                          'imageFile',
                          imageBytes!,
                          filename: 'image.png',
                          contentType: MediaType('image', 'png'),
                        ),
                      );
                    },
                    widget: imageAccepted && !imageCropped
                      ? CircularProgressIndicator()
                      : Text(
                          'Anvend billede',
                          style: AppTextStyles.buttonTextMedium,
                        ),
                    blocked: imageAccepted
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    onTab: () {
                      setState(() {
                        imageBytes = null;
                        imagePicked = false;
                        imageCropped = false;
                        imageAccepted = false;
                        _setupCameraController();
                      });
                    },
                    text: 'Fortryd',
                    backgroundColor: AppColors.secondary,
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
  Widget _buttonPanel(BuildContext context) {
    return Container(
      height: 120, // Fixed height for the control panel.
      padding: const EdgeInsets.all(15), // Insets the buttens 15 pixels from the edge of the screen.
      child: Row( // Horizontal layout for the control buttons.
        mainAxisAlignment: MainAxisAlignment.start, // Aligns buttons to the start of the row.
        children: <Widget>[
          Flexible(child: _pickFromGalleryButton(context)), // Button to access the image gallery.
          Flexible(child: _takePictureButton(context)), // Button to take a picture with the camera.
          Spacer(), // Creates some space between the former and next widgets.
        ],
      ),
    );
  }

  /// The method which creates the button for opening the gallery through the camera.
  Widget _pickFromGalleryButton(context) {
    return Align( // Allows the widget to be alligned.
      alignment: Alignment.centerLeft, // Aligns button to the center left.
      child: Row( // Horizontal layout for the buttons.
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Evenly spaces the buttons.
        mainAxisSize: MainAxisSize.min, // Allows the row to take up minimal width.
        children: <Widget>[
          FloatingActionButton( // Button for opening the gallery.
            backgroundColor: AppColors.secondary, // Sets background color for the button.
            onPressed: () => _pickImageFromGallery(),
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
  Widget _takePictureButton(BuildContext context) {
    return Align( // Centers the button within the expanded widget.
      alignment: Alignment.center, // Aligns the button to the center.
      child: SingleChildScrollView( // Creates a box which is scrollable.
        scrollDirection: Axis.horizontal, // Makes the box scroll horizontally.
        child: Row( // Horizontal layout for the buttons within the control panel.
          mainAxisAlignment: MainAxisAlignment.center, // Aligns horizontally to the center.
          children: <Widget>[
            FloatingActionButton( // Represents the button to take a picture.
              backgroundColor: AppColors.primary, // Sets the background color for the button.
              onPressed: () => _takePicture(),
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
  Future<void> _cropImageToSquare() async {
    final img.Image? decodedImage = img.decodeImage(imageBytes!);; // Decodes the image from the MultipartFile as bytes.

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

      setState(() { // Updates the state.
        this.imageBytes = croppedImage.getBytes();
        imageCropped = true;
      });
    }
  }

  Future<void> _takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized) { // Checks if the camera controller is null or not initialized.
      return; // Exits the method.
    }

    try { // Tries to run the following code, and catches any errors that occurs.
      final XFile picture = await cameraController!.takePicture(); // Makes the device take a picture.
      setState(() async {
        imageBytes = await picture.readAsBytes(); // Reads the picture as bytes.
        imagePicked = true;
      });
      await _cropImageToSquare(); // Crops the image into a square.
    } catch (e) { // Catches any errors.
      print("Error taking picture: $e");
    }
  }

  /// The method which creates the button for opening the gallery through the camera.
  Future<void> _pickImageFromGallery() async {
    imagePicker ??= ImagePicker();

    final returnedImage = await imagePicker!.pickImage(source: ImageSource.gallery);
    if (returnedImage != null) {
      setState(() async {
        imageBytes = await returnedImage.readAsBytes();
        imagePicked = true;
      });
      await _cropImageToSquare();
    }
  }
}