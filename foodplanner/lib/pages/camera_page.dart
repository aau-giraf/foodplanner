import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:http/http.dart';
import 'package:image/image.dart' as img;
import 'package:http_parser/http_parser.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:foodplanner/config/colors.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({
    super.key,
  });

  @override
  State<CameraPage> createState() => _MealPageState();
}

class _MealPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _initializeControllerFuture = _initializeCamera();
    _checkAndRequestPermission();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAndRequestPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      var newStatus = await Permission.camera.request();
      if (newStatus.isPermanentlyDenied) {
        // Show dialog to guide the user to the app settings
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text('Kamera Adgang'),
              content: Text(
                  'Tillad adgang til kameraet for at tage billeder i app indstillingerne.'),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    openAppSettings().then((_) {
                      // Refresh the permission status after returning from settings
                      setState(() {});
                    });
                  },
                  child: const Text("Gå til indstillinger"),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Annuller"),
                ),
              ],
            ),
          );
        });
      }
    }
  }

  Widget _cameraPreview() {
    return FutureBuilder<void>(
      future: Permission.camera.status,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            var status = snapshot.data as PermissionStatus;
            print(status);
            if (status.isGranted) {
              return CameraPreview(_controller);
            } else if (status.isPermanentlyDenied) {
              // Show a message or an alternative UI
              return Center(
                child: Text(
                    'Kamera adgang er permanent nægtet. Gå til indstillinger for at tillade adgang.'),
              );
            } else {
              // Show a message or an alternative UI
              return Center(
                child: Text(
                    'Kamera adgang er nægtet. Tillad adgang for at bruge kameraet.'),
              );
            }
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              Navigator.pop(context, null);
            },
            child: Row(
              children: [
                SFIcon(SFIcons.sf_chevron_backward),
                SizedBox(width: 10),
                Text(
                  'Tilbage',
                  style: AppTextStyles.headline4,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
        leadingWidth: 200,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _cameraPreview();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              heroTag: 'galleryButton',
              child: SFIcon(SFIcons.sf_photo_on_rectangle_angled),
            ),
          ),
          Positioned(
            bottom: 20,
            right: MediaQuery.of(context).size.width / 2 - 28,
            child: FloatingActionButton(
              onPressed: () async {
                try {
                  await _initializeControllerFuture;
                  final image = await _controller.takePicture();

                  if (!context.mounted) return;

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayPictureScreen(image: image),
                    ),
                  );
                } catch (e) {
                  print('Error taking picture: $e');
                }
              },
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              heroTag: 'cameraButton',
              child: SFIcon(SFIcons.sf_camera_fill),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final XFile image;
  late MultipartFile croppedImage;

  DisplayPictureScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              Navigator.pop(context, null);
            },
            child: Row(
              children: [
                SFIcon(SFIcons.sf_chevron_backward),
                SizedBox(width: 10),
                Text(
                  'Tilbage',
                  style: AppTextStyles.headline4,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
        leadingWidth: 200,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: cropImageToSquare(image),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 60),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(snapshot.data!),
                      ),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              onTab: () {
                                Navigator.pop(context);
                                Navigator.pop(context, image);
                              },
                              text: 'Anvend billede',
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: CustomButton(
                              onTab: () {
                                Navigator.pop(context, null);
                              },
                              text: 'Fortryd',
                              backgroundColor: AppColors.secondary,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

// A method for cropping the inputted image's size.
Future<Uint8List> cropImageToSquare(XFile image) async {
  var multipartFile = MultipartFile.fromBytes(
    'imageFile',
    await image.readAsBytes(),
    filename: 'image.png',
    contentType: MediaType('image', 'png'),
  );

  final img.Image? decodedImage =
      img.decodeImage(await multipartFile.finalize().toBytes());

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

    // Updates the state.
    return await MultipartFile.fromBytes(
      'imageFile',
      croppedBytes,
      filename: 'image.png',
      contentType: MediaType('image', 'jpeg'),
    ).finalize().toBytes();
  } else {
    print('Error decoding image');
    return multipartFile.finalize().toBytes();
  }
}
