import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/pages/camera_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CameraPage UI Tests', () {
    testWidgets('shows CircularProgressIndicator while loading', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CameraPage()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows CameraPreview after initialization', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CameraPage()));

      await tester.pumpAndSettle();

      expect(find.byType(CameraPreview), findsOneWidget);
    });

    testWidgets('FloatingActionButtons are present', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CameraPage()));

      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsNWidgets(2));
    });

    testWidgets('tap on camera button does not crash', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CameraPage()));

      await tester.pumpAndSettle();

      final cameraButton = find.byIcon(Icons.camera);
      expect(cameraButton, findsOneWidget);

      await tester.tap(cameraButton);
      await tester.pumpAndSettle();
    });

    testWidgets('tap on gallery button does not crash', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CameraPage()));

      await tester.pumpAndSettle();

      final galleryButton = find.byIcon(Icons.collections);
      expect(galleryButton, findsOneWidget);

      await tester.tap(galleryButton);
      await tester.pumpAndSettle();
    });
  });
}
