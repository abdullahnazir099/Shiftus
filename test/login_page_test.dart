import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cargo_connect_testing/BusinessLogic/Firestore.dart';
import 'package:cargo_connect_testing/pages/UserManagement/Login.dart';
import 'package:cargo_connect_testing/pages/UserManagement/EnterOTP.dart';
import 'package:cargo_connect_testing/pages/UserManagement/Registration.dart';
import 'package:cargo_connect_testing/pages/CommonFunctions.dart';
import 'mocks.mocks.dart';

void main() {
  group('LoginPage Widget Tests', () {
    late MockFirestoreManager mockFirestoreManager;
    late TextEditingController phoneNumberController;

    setUp(() {
      mockFirestoreManager = MockFirestoreManager();
      phoneNumberController = TextEditingController();
    });

    Future<void> _buildLoginPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginPage(),
        ),
      );
    }

    testWidgets('Test UI elements', (WidgetTester tester) async {
      await _buildLoginPage(tester);

      // Verify the presence of UI elements
      expect(find.text("Login"), findsOneWidget);
      expect(find.text("Send OTP"), findsOneWidget);
      expect(find.text("Sign Up"), findsOneWidget);
    });

    testWidgets('Test phone number field is empty', (WidgetTester tester) async {
      await _buildLoginPage(tester);

      // Simulate tapping the "Send OTP" button
      await tester.tap(find.text("Send OTP"));
      await tester.pump();

      // Verify that the toast message is shown
      expect(find.text("Fields are empty, please fill all fields"), findsOneWidget);
    });

    testWidgets('Test user exists and navigate to EnterOTP', (WidgetTester tester) async {
      when(mockFirestoreManager.verifyUserExists(any))
          .thenAnswer((_) async => true);

      await _buildLoginPage(tester);

      // Enter phone number
      await tester.enterText(find.byType(TextField).first, "1234567890");

      // Simulate tapping the "Send OTP" button
      await tester.tap(find.text("Send OTP"));
      await tester.pumpAndSettle();

      // Verify that the EnterOTP page is pushed
      expect(find.byType(EnterOTP), findsOneWidget);
      verify(mockFirestoreManager.verifyUserExists("1234567890")).called(1);
    });

    testWidgets('Test user does not exist and navigate to Registration', (WidgetTester tester) async {
      when(mockFirestoreManager.verifyUserExists(any))
          .thenAnswer((_) async => false);

      await _buildLoginPage(tester);

      // Enter phone number
      await tester.enterText(find.byType(TextField).first, "1234567890");

      // Simulate tapping the "Send OTP" button
      await tester.tap(find.text("Send OTP"));
      await tester.pumpAndSettle();

      // Verify that the RegistrationPage page is pushed
      expect(find.byType(RegistrationPage), findsOneWidget);
      verify(mockFirestoreManager.verifyUserExists("1234567890")).called(1);
    });

    testWidgets('Test resend OTP functionality', (WidgetTester tester) async {
      await _buildLoginPage(tester);

      // Simulate tapping the "Resend" button
      await tester.tap(find.text("Resend"));
      await tester.pump();

      // Verify that the resend counter is shown
      expect(find.text("00:59"), findsOneWidget);
    });
  });
}
