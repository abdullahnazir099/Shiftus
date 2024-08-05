import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cargo_connect_testing/pages/UserManagement/EnterOTP.dart';
import 'package:otp_text_field/otp_field.dart';
import 'mocks.mocks.dart';

void main() {
  group('EnterOTP Widget Tests', () {
    late MockFirebaseManager mockFirebaseManager;
    late MockFirestoreManager mockFirestoreManager;

    setUp(() {
      mockFirebaseManager = MockFirebaseManager();
      mockFirestoreManager = MockFirestoreManager();
    });

    Future<void> _buildEnterOTP(WidgetTester tester, bool forRegistration) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EnterOTP(forRegistration: forRegistration),
        ),
      );
    }

    testWidgets('Test OTP submission success', (WidgetTester tester) async {
      // Update the mock method calls with proper arguments
      when(mockFirebaseManager.verifyPhoneNumberFirebase(
        any,
        any,
      )).thenAnswer((_) async => print('OTP sent'));

      when(mockFirebaseManager.enterOTP(
        any,
        any,
      )).thenAnswer((_) async => true);

      when(mockFirestoreManager.addUser(
        any,
        any,
        any,
        any,
      )).thenAnswer((_) async => print('User added'));

      await _buildEnterOTP(tester, true);

      // Simulate entering OTP
      await tester.enterText(find.byType(OtpTextField), '123456');
      await tester.tap(find.text("Let's go!"));
      await tester.pump();

      // Verify the OTP submission process
      verify(mockFirebaseManager.enterOTP('123456', any)).called(1);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Test OTP submission failure', (WidgetTester tester) async {
      // Update the mock method calls with proper arguments
      when(mockFirebaseManager.verifyPhoneNumberFirebase(
        any,
        any,
      )).thenAnswer((_) async => print('OTP sent'));

      when(mockFirebaseManager.enterOTP(
        any,
        any,
      )).thenAnswer((_) async => false);

      await _buildEnterOTP(tester, true);

      // Simulate entering OTP
      await tester.enterText(find.byType(OtpTextField), '654321');
      await tester.tap(find.text("Let's go!"));
      await tester.pump();

      // Verify the OTP submission process
      verify(mockFirebaseManager.enterOTP('654321', any)).called(1);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Test UI elements', (WidgetTester tester) async {
      await _buildEnterOTP(tester, true);

      // Verify the presence of UI elements
      expect(find.byType(OtpTextField), findsOneWidget);
      expect(find.text("Let's go!"), findsOneWidget);
    });
  });
}
