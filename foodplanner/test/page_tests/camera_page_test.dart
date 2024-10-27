import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/pages/cameraPage.dart';

// Mock classes
class MockCameraController extends Mock implements CameraController {}

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  late MockCameraController mockCameraController;
  late MockImagePicker mockImagePicker;

  setUp(() {
    mockCameraController = MockCameraController();
    mockImagePicker = MockImagePicker();
    
    // Create a CameraDescription
    final cameraDescription = CameraDescription(
      name: 'back',
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 90,
    );

    // Set up a valid CameraValue
    when(mockCameraController.value).thenReturn(CameraValue(
      isInitialized: true,
      isRecordingVideo: false,
      isTakingPicture: false,
      isStreamingImages: false,
      isRecordingPaused: false,
      flashMode: FlashMode.off,
      exposureMode: ExposureMode.auto,
      focusMode: FocusMode.auto,
      exposurePointSupported: false,
      focusPointSupported: false,
      deviceOrientation: DeviceOrientation.portraitUp,
      previewSize: Size(1170, 2532),
      description: cameraDescription, // Pass the CameraDescription here
    ));
  });

  group('CameraPage Widget Tests', () {
    testWidgets('should show CircularProgressIndicator when camera is not initialized', (WidgetTester tester) async {
      // Mock the CameraController to return an uninitialized state
      when(mockCameraController.value).thenReturn(CameraValue(
        isInitialized: false,
        isRecordingVideo: false,
        isTakingPicture: false,
        isStreamingImages: false,
        isRecordingPaused: false,
        flashMode: FlashMode.off,
        exposureMode: ExposureMode.auto,
        focusMode: FocusMode.auto,
        exposurePointSupported: false,
        focusPointSupported: false,
        deviceOrientation: DeviceOrientation.portraitUp,
        previewSize: Size(1170, 2532),
        description: CameraDescription(
          name: 'back',
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 90,
        ),
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: CameraPage(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display CameraPreview when camera is initialized', (WidgetTester tester) async {
      // Mock the CameraController to return an initialized state
      when(mockCameraController.value).thenReturn(CameraValue(
        isInitialized: true,
        isRecordingVideo: false,
        isTakingPicture: false,
        isStreamingImages: false,
        isRecordingPaused: false,
        flashMode: FlashMode.off,
        exposureMode: ExposureMode.auto,
        focusMode: FocusMode.auto,
        exposurePointSupported: false,
        focusPointSupported: false,
        deviceOrientation: DeviceOrientation.portraitUp,
        previewSize: Size(1170, 2532),
        description: CameraDescription(
          name: 'back',
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 90,
        ),
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: CameraPage(),
        ),
      );

      expect(find.byType(CameraPreview), findsOneWidget);
    });

    testWidgets('should take picture on FloatingActionButton press', (WidgetTester tester) async {
      when(mockCameraController.takePicture()).thenAnswer((_) async => XFile('path/to/file'));

      await tester.pumpWidget(
        MaterialApp(
          home: CameraPage(),
        ),
      );

      await tester.tap(find.byIcon(Icons.camera));
      await tester.pump();

      verify(mockCameraController.takePicture()).called(1);
    });

    testWidgets('should open gallery on FloatingActionButton press', (WidgetTester tester) async {
      when(mockImagePicker.pickImage(source: ImageSource.gallery)).thenAnswer((_) async => XFile('path/to/file'));

      await tester.pumpWidget(
        MaterialApp(
          home: CameraPage(),
        ),
      );

      await tester.tap(find.byIcon(Icons.collections));
      await tester.pump();

      verify(mockImagePicker.pickImage(source: ImageSource.gallery)).called(1);
    });

    testWidgets('should handle null image selection gracefully', (WidgetTester tester) async {
      when(mockImagePicker.pickImage(source: ImageSource.gallery)).thenAnswer((_) async => null);

      await tester.pumpWidget(
        MaterialApp(
          home: CameraPage(),
        ),
      );

      await tester.tap(find.byIcon(Icons.collections));
      await tester.pump();

      verify(mockImagePicker.pickImage(source: ImageSource.gallery)).called(1);
    });

    testWidgets('should handle app lifecycle changes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CameraPage(),
        ),
      );

      TestWidgetsFlutterBinding.ensureInitialized();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);

      verify(mockCameraController.dispose()).called(1);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

      // Cannot directly verify private method calls, ensure this indirectly
      await tester.pump();
    });
  });
}