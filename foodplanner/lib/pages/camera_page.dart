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

class CameraPage extends StatefulWidget {
  final CameraController? controller;
  final ImagePicker? imagePicker;
  final ValueSetter onImagePicked;

  const CameraPage({
    super.key,
    this.controller,
    this.imagePicker,
    required this.onImagePicked,
  });

  static const String routeName = '/camera_page';

  @override
  State<CameraPage> createState() => _MealPageState();
}

class _MealPageState extends State<CameraPage> with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  ImagePicker? imagePicker;
  File? image;
  Uint8List? webImageBytes; // Used to store the image bytes for web

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (cameraController == null || cameraController?.value.isInitialized == false) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _setupCameraController();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      cameraController = widget.controller;
      imagePicker = widget.imagePicker ?? ImagePicker();
    } else {
      _setupCameraController();
      imagePicker = ImagePicker();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || cameraController?.value.isInitialized == false) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: image == null && webImageBytes == null
          ? SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: AspectRatio(
                      aspectRatio: cameraController!.value.aspectRatio,
                      child: CameraPreview(cameraController!),
                    ),
                  ),
                  // Positioned.fill(
                  //   child: CustomPaint(
                  //     painter: CustomSquareCameraOverlay(),
                  //   ),
                  // ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _controlPanel(context),
                  ),
                ],
              ),
            )
          : _acceptImage(context),
    );
  }

  Widget _acceptImage(BuildContext context) {
    final displayImage = kIsWeb
        ? Image.memory(webImageBytes!) // Display image as bytes for web
        : Image.file(image!); // Display image as a file for mobile

    return Container(
      child: Center(
        child: Column(
          children: [
            Spacer(),
            Container(
              width: MediaQuery.sizeOf(context).width > MediaQuery.sizeOf(context).height
                  ? MediaQuery.sizeOf(context).height
                  : MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).width > MediaQuery.sizeOf(context).height
                  ? MediaQuery.sizeOf(context).height
                  : MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
                        widget.onImagePicked(image ?? webImageBytes);
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
                        webImageBytes = null;
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

  Widget _controlPanel(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(child: _galleryControlWidget(context)),
          Flexible(child: _cameraControlWidget(context)),
          Spacer(),
        ],
      ),
    );
  }

  Widget _galleryControlWidget(context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: AppColors.secondary,
            onPressed: () {
              _pickImageFromGallery();
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height),
            ),
            child: const Icon(
              Icons.collections,
              color: AppColors.background,
            ),
          )
        ],
      ),
    );
  }

  Widget _cameraControlWidget(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () async {
                if (cameraController == null || !cameraController!.value.isInitialized) {
                  return;
                }

                try {
                  final XFile picture = await cameraController!.takePicture();
                  if (kIsWeb) {
                    webImageBytes = await picture.readAsBytes();
                    await cropImageToSquare(webImageBytes!);
                  } else {
                    image = File(picture.path);
                    await cropImageToSquare(image!);
                  }
                  setState(() {});
                } catch (e) {
                  print("Error taking picture: $e");
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MediaQuery.sizeOf(context).height),
              ),
              child: const Icon(
                Icons.camera,
                color: AppColors.background,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> cropImageToSquare(dynamic inputImage) async {
    final img.Image? decodedImage;
    if (inputImage is File) {
      decodedImage = img.decodeImage(await inputImage.readAsBytes());
    } else if (inputImage is Uint8List) {
      decodedImage = img.decodeImage(inputImage);
    } else {
      throw ArgumentError('Invalid image type');
    }

    if (decodedImage != null) {
      final width = decodedImage.width;
      final height = decodedImage.height;
      final squareSize = width < height ? width : height;
      final croppedImage = img.copyCrop(
        decodedImage,
        (width - squareSize) ~/ 2,
        (height - squareSize) ~/ 2,
        squareSize,
        squareSize,
      );
      final croppedBytes = img.encodeJpg(croppedImage);

      setState(() {
        if (kIsWeb) {
          webImageBytes = Uint8List.fromList(croppedBytes);
        } else {
          final tempPath = inputImage.path.replaceFirst('.jpg', '_cropped.jpg');
          final croppedFile = File(tempPath);
          croppedFile.writeAsBytesSync(croppedBytes);
          image = croppedFile;
        }
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final returnedImage = await imagePicker!.pickImage(source: ImageSource.gallery);
    if (returnedImage != null) {
      if (kIsWeb) {
        webImageBytes = await returnedImage.readAsBytes();
        await cropImageToSquare(webImageBytes!);
      } else {
        image = File(returnedImage.path);
        await cropImageToSquare(image!);
      }
      setState(() {});
    }
  }

  Future<void> _setupCameraController() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        cameraController = CameraController(cameras.first, ResolutionPreset.high);
      });
      await cameraController?.initialize();
      if (mounted) setState(() {});
    }
  }
}