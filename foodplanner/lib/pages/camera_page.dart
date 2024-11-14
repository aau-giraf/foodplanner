import 'dart:io' show File;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/components/button.dart';
import 'package:http/http.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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
  MultipartFile? image; // The selected image's file.

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
      body: image == null
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

  /// Widget to display the selected image.
  Widget _acceptImage(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: image!.finalize().toBytes(), // Fetch the image bytes asynchronously.
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
        final multipartFile = http.MultipartFile.fromBytes(
          'imageFile', // Field name for the file in the request
          snapshot.data!, // The actual Uint8List data
          filename: 'image.png', // Optional: specify a filename if required
          contentType: MediaType('image', 'png'), // Optional: specify the content type
        );
        print('Media type: ${multipartFile.contentType}');

        // Display the image and use the MultipartFile as needed
        final displayImage = Image.memory(snapshot.data!); // Display the Uint8List as an image.


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
                    child: displayImage,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CustomButton(
                          onTab: () {
                            setState(() {
                              widget.onImagePicked(multipartFile); // Use the picked image.
                            });
                          },
                          text: 'Anvend billede',
                        ),
                      ),
                      Expanded(
                        child: CustomButton(
                          onTab: () {
                            setState(() {
                              image = null;
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
        } else {
          return Center(child: Text('No image available'));
        }
      },
    );
  }

  // /// The method which 
  // Widget _acceptImage(BuildContext context) {
  //   final displayImage = Image.memory(this.image!.finalize().toBytes());

  //   return Container(
  //     child: Center( // Alligns the widget to the center.
  //       child: Column( // Vertical layout for the body.
  //         children: [
  //           Spacer(), // Creates an empty space.
  //           Container( // Container used for determining the size of the display image.
  //             width: MediaQuery.sizeOf(context).width > MediaQuery.sizeOf(context).height // Checks if the width is larger than the height of the device. This is done to create the smallest square for the display.
  //                 ? MediaQuery.sizeOf(context).height // If so, sets the width as the height of the device.
  //                 : MediaQuery.sizeOf(context).width, // If not, sets the width as the width of the device.
  //             height: MediaQuery.sizeOf(context).width > MediaQuery.sizeOf(context).height // Checks if the height is larger than the width of the device. This is done to create the smallest square for the display.
  //                 ? MediaQuery.sizeOf(context).height // If so, sets the height as the width of the device.
  //                 : MediaQuery.sizeOf(context).width, // If not, sets the height as the height of the device.
  //             decoration: BoxDecoration( // Used for changing the appearance of the display image.
  //               borderRadius: BorderRadius.circular(20), // Determines the rounded corner of the rectangle should have a radius of 20.
  //             ),
  //             child: displayImage, // Creates the widget for the display image.
  //           ),
  //           Row( // Horizontal layout for the body.
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Spaces the layout evenly 
  //             children: [
  //               Expanded( // Fills the available space of the row.
  //                 child: CustomButton( // Creates a custom made button for using the displayed image.
  //                   onTab: () { // When clicked, uses the picked image.
  //                     setState(() {
  //                       widget.onImagePicked(image); // Sets the picked image to be the image selected image.
  //                     });
  //                   },
  //                   text: 'Anvend billede', // Text that is displayed on the button.
  //                 ),
  //               ),
  //               Expanded( // Fills the available space.
  //                 child: CustomButton( // Creates a custom button for cancelling the image selection.
  //                   onTab: () { // When clicked, sets the body back to the camera controller for taking another picture.
  //                     setState(() { // Updates the state of the page.
  //                       image = null; // Sets the selected image as null.
  //                       _setupCameraController(); // Sets up the camera controller.
  //                     });
  //                   },
  //                   text: 'Fortryd', // Text that is displayed on the button.
  //                   backgroundColor: AppColors.secondary, // The background color of the button.
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Spacer(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
                  image = MultipartFile.fromBytes(
                    'imageFile',
                    await picture.readAsBytes()
                  ); // Reads the picture as bytes.
                  await cropImageToSquare(); // Crops the image into a square.
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
  Future<void> cropImageToSquare() async {
    final img.Image? decodedImage = img.decodeImage(await this.image!.finalize().toBytes());; // Decodes the image from the MultipartFile as bytes.

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
        this.image = MultipartFile.fromBytes(
          'imageFile',
          croppedBytes,
          filename: image?.filename,
          contentType: MediaType('image', 'jpeg'),
        );
      });
    }
  }

  /// The method which creates the button for opening the gallery through the camera.
  Future<void> _pickImageFromGallery() async {
  imagePicker ??= ImagePicker();

  final returnedImage = await imagePicker!.pickImage(source: ImageSource.gallery);
  if (returnedImage != null) {
    final bytes = await returnedImage.readAsBytes();
    image = http.MultipartFile.fromBytes(
      'imageFile',
      bytes,
      filename: returnedImage.name,
      contentType: MediaType('image', 'jpeg'),
    );
    await cropImageToSquare();
    setState(() {});
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