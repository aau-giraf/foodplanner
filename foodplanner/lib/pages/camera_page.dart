import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  final CameraController? controller;
  final ImagePicker? imagePicker;

  const CameraPage({this.controller, this.imagePicker, Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  bool _isInitialized = false;
  final ImagePicker _defaultPicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        CameraController(
          const CameraDescription(
            name: 'Default',
            lensDirection: CameraLensDirection.back,
            sensorOrientation: 0,
          ),
          ResolutionPreset.medium,
        );

    _controller!.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        final XFile file = await _controller!.takePicture();
        print('Picture taken: ${file.path}');
      } catch (e) {
        print('Error taking picture: $e');
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = widget.imagePicker ?? _defaultPicker;
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        print('Image selected: ${image.path}');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Camera Page')),
      body: Column(
        children: [
          Expanded(child: CameraPreview(_controller!)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                heroTag: 'camera',
                onPressed: _takePicture,
                child: const Icon(Icons.camera_alt),
              ),
              FloatingActionButton(
                heroTag: 'gallery',
                onPressed: _pickFromGallery,
                child: const Icon(Icons.photo_library),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
