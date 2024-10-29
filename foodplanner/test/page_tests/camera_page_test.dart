import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/pages/camera_page.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart';

import 'camera_page_test.mocks.dart';

@GenerateMocks([CameraController, ImagePicker])
void main() {
  // Ensures the binding for the widgets is initialized.
  TestWidgetsFlutterBinding.ensureInitialized();  

  late MockCameraController mockCameraController;
  late MockImagePicker mockImagePicker;
  late List<CameraDescription> cameras;

  // This setup runs once before all the tests.
  setUpAll(() async {
    cameras = [
      CameraDescription(
        name: 'Test Camera',
        lensDirection: CameraLensDirection.back,
        sensorOrientation: 0,
      ),
    ];
    mockCameraController = MockCameraController();
    mockImagePicker = MockImagePicker();
  });

  // This setup runs before each test.
  setUp(() {
    reset(mockCameraController);
    reset(mockImagePicker);

    // Mocking the CameraController's initial value and behaviors.
    when(mockCameraController.value).thenReturn(CameraValue(
      isInitialized: true,
      isRecordingVideo: false,
      isTakingPicture: false,
      isStreamingImages: false,
      isRecordingPaused: false,
      flashMode: FlashMode.auto,
      exposureMode: ExposureMode.auto,
      focusMode: FocusMode.auto,
      exposurePointSupported: false,
      focusPointSupported: false,
      deviceOrientation: DeviceOrientation.portraitUp,
      description: cameras.first,
      previewSize: Size(640, 480),
    ));

    // Mocking the initialize method.
    when(mockCameraController.initialize()).thenAnswer((_) async {
      when(mockCameraController.value).thenReturn(CameraValue(
        isInitialized: true,
        isRecordingVideo: false,
        isTakingPicture: false,
        isStreamingImages: false,
        isRecordingPaused: false,
        flashMode: FlashMode.auto,
        exposureMode: ExposureMode.auto,
        focusMode: FocusMode.auto,
        exposurePointSupported: false,
        focusPointSupported: false,
        deviceOrientation: DeviceOrientation.portraitUp,
        description: cameras.first,
        previewSize: Size(640, 480),
      ));
    });

    // Mocking the takePicture method.
    when(mockCameraController.takePicture()).thenAnswer((_) async => XFile('test_image.jpg'));

    // Mocking the buildPreview method.
    when(mockCameraController.buildPreview()).thenReturn(Container());

    // Mocking the pickImage method of the ImagePicker.
    when(mockImagePicker.pickImage(source: ImageSource.gallery)).thenAnswer((_) async => XFile('test_image.jpg'));
  });

  group('Camera Page Tests', () {
    group('Camera Initialization Tests', () {
      // Testing if the camera initializes and shows the preview correctly.
      testWidgets('should initialize camera and show preview', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(
          home: CameraPage(
            controller: mockCameraController,
            client: Client(),
          )
        ));

        // Act
        await tester.pump();

        // Assert
        expect(find.byType(CameraPreview), findsOneWidget);
      });

      // Testing the behavior when the camera is not available.
      testWidgets('should handle camera not available', (WidgetTester tester) async {
        // Arrange
        when(mockCameraController.value).thenReturn(CameraValue.uninitialized(cameras.first));
        
        // Act
        await tester.pumpWidget(MaterialApp(
          home: CameraPage(
            controller: mockCameraController,
            client: Client(),
          )
        ));
        await tester.pump();

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      // Testing the behavior when the camera controller is null.
      testWidgets('should handle null camera controller gracefully', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(
          home: CameraPage(
            controller: null,
            client: Client(),
          )
        ));

        // Act
        await tester.pump();

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('User Interaction Tests', () {
      // Testing the behavior when the camera button is pressed.
      testWidgets('should take a picture when camera button is pressed', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(
          home: CameraPage(
            controller: mockCameraController,
            client: Client(),
          )
        ));
        await tester.pump();
        
        // Act
        await tester.tap(find.byIcon(Icons.camera));
        await tester.pumpAndSettle();

        // Assert
        verify(mockCameraController.takePicture()).called(1);
      });

      // Testing the behavior when the gallery button is pressed.
      testWidgets('should open gallery when gallery button is pressed', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(
          home: CameraPage(
            controller: mockCameraController, 
            imagePicker: mockImagePicker,
            client: Client(),
          )
        ));

        await tester.pump();

        // Act
        await tester.tap(find.byIcon(Icons.collections));
        await tester.pumpAndSettle();

        // Assert
        verify(mockImagePicker.pickImage(source: ImageSource.gallery)).called(1);
      });
    });
  });
}