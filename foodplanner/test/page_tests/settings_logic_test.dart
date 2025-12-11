import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// Importerer de nødvendige modeller og service-interface
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/pages/settings/settings.dart';
import 'package:foodplanner/auth/auth_provider.dart'; 
import 'package:foodplanner/models/user_roles.dart';

import 'test_helper_settings.mocks.dart';


void main() {
  late MockUserService mockUserService;
  late MockAuthProvider mockAuthProvider;

  setUp(() {
    mockUserService = MockUserService();
    mockAuthProvider = MockAuthProvider();

    final initialUser = User(
      id: 1,
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'Bruger',
      role: UserRoles.empty(),
      archived: false,
    );

    when(mockUserService.fetchLoggedInUser()).thenAnswer((_) async => initialUser);

    when(mockUserService.updateUser(any, any, any, any)).thenAnswer((_) async => http.Response('Success', 200));

    when(mockUserService.updatePassword(any)).thenAnswer((_) async => {});

    when(mockUserService.updatePincode(any)).thenAnswer((_) async => {});
  });

  Future<SettingsState> loadSettingsState(WidgetTester tester) async {
    //byg UI
    await tester.pumpWidget(MultiProvider(
      providers: [ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
      ],
      child: const MaterialApp(home: Settings()),
      )
    );

    //inject mock
    final state = tester.state<SettingsState>(find.byType(Settings));
    
    //aktiver mocken
    state.userService = mockUserService;
    
    //tving opdatering via mocken
    await state.resetPage();
    
    //vent på UI updatere med ny data
    await tester.pumpAndSettle();
    return state;
  }

  group('Settings Logic Tests', () {
    testWidgets('InitState fetches and saves the users data correct', (tester) async {
      final state = await loadSettingsState(tester);

      verify(mockUserService.fetchLoggedInUser()).called(1);
      expect(state.currentUser.firstName, 'Test');
      expect(state.numberOfEdits, 0);
    });

    testWidgets('Ændringer i felter opdaterer "numberOfEdits', (tester) async {
      final state = await loadSettingsState(tester);

      state.updateFirstName('John');
      expect(state.isFirstNameEdited, true);
      expect(state.numberOfEdits, 1);

      state.updateLastName('Doe');
      expect(state.numberOfEdits, 2);

      state.updateFirstName('Test');
      expect(state.numberOfEdits, 1);
    });

    testWidgets('saveChanges kalder API med korrekte data', (tester) async {
      final state = await loadSettingsState(tester);

      //arrange
      state.updateFirstName('NewName');
      state.updatePassword('Testing123');

      //act
      await state.saveChanges();

      //assert
      verify(mockUserService.updateUser(any, 'NewName', any, any));
      verify(mockUserService.updatePassword('Testing123'));

      //man kan også teste at det andet ikke blev kaldt
      verifyNever(mockUserService.updatePassword(any));
    });

    testWidgets('discardChanges nulstiller alt', (tester) async {
      final state = await loadSettingsState(tester);

      state.updateFirstName('WrongName');

      state.discardChanges();

      expect(state.editedData.firstName, 'Test');
      expect(state.numberOfEdits, 0);
    });
  });
}