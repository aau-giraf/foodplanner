import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/pages/camera_page.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'camera_page_test.mocks.dart';

@GenerateMocks([CameraController, ImagePicker])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  late MockCameraController mockCameraController;
  late MockImagePicker mockImagePicker;
  late List<CameraDescription> cameras;

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

  setUp(() {
    reset(mockCameraController);
    reset(mockImagePicker);

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
    
    when(mockCameraController.takePicture()).thenAnswer((_) async => XFile('test_image.jpg'));
    when(mockCameraController.buildPreview()).thenReturn(Container());
    when(mockImagePicker.pickImage(source: ImageSource.gallery)).thenAnswer((_) async => XFile('test_image.jpg'));
  });

  group('Camera Page Tests', () {
    group('Camera Initialization Tests', () {
      testWidgets('should initialize camera and show preview', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: CameraPage(controller: mockCameraController)));
        await tester.pump();
        
        expect(find.byType(CameraPreview), findsOneWidget);
      });

      testWidgets('should handle camera not available', (WidgetTester tester) async {
        when(mockCameraController.value).thenReturn(CameraValue.uninitialized(cameras.first));
        
        await tester.pumpWidget(MaterialApp(home: CameraPage(controller: mockCameraController)));
        await tester.pump();
        
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('should handle null camera controller gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: CameraPage(controller: null)));
        await tester.pump();
        
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });

    group('User Interaction Tests', () {
      testWidgets('should take a picture when camera button is pressed', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: CameraPage(controller: mockCameraController)));
        await tester.pump();
        
        await tester.tap(find.byIcon(Icons.camera));
        await tester.pumpAndSettle();
        
        verify(mockCameraController.takePicture()).called(1);
      });

      testWidgets('should open gallery when gallery button is pressed', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: CameraPage(controller: mockCameraController, imagePicker: mockImagePicker)));
        await tester.pump();
        
        await tester.tap(find.byIcon(Icons.collections));
        await tester.pumpAndSettle();
        
        verify(mockImagePicker.pickImage(source: ImageSource.gallery)).called(1);
      });
    });
  });
}