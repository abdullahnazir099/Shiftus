import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cargo_connect_testing/pages/UserManagement/Registration.dart';
import 'package:cargo_connect_testing/pages/UserManagement/EnterOTP.dart';

void main() {
  group('RegistrationPage Widget Tests', () {
    Future<void> _buildRegistrationPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RegistrationPage(),
        ),
      );
    }

    testWidgets('Test UI elements', (WidgetTester tester) async {
      await _buildRegistrationPage(tester);

      // Verify the presence of UI elements
      expect(find.text("Register"), findsOneWidget);
      expect(find.text("Send OTP"), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    });

    testWidgets('Test empty fields show toast message', (WidgetTester tester) async {
      await _buildRegistrationPage(tester);

      // Simulate tapping the "Send OTP" button
      await tester.tap(find.text("Send OTP"));
      await tester.pump();

      // Verify that the toast message is shown
      expect(find.text("Fields are empty, please fill all fields"), findsOneWidget);
    });

    testWidgets('Test valid registration data navigates to EnterOTP', (WidgetTester tester) async {
      await _buildRegistrationPage(tester);

      // Enter name
      await tester.enterText(find.byType(TextField).at(0), "John Doe");

      // Enter CNIC
      await tester.enterText(find.byType(TextField).at(1), "12345-6789012-3");

      // Enter phone number
      await tester.enterText(find.byType(TextField).at(2), "+923001234567");

      // Select location
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Lahore").last);
      await tester.pumpAndSettle();

      // Simulate tapping the "Send OTP" button
      await tester.tap(find.text("Send OTP"));
      await tester.pumpAndSettle();

      // Verify that the EnterOTP page is pushed
      expect(find.byType(EnterOTP), findsOneWidget);
    });

    testWidgets('Test registration with missing fields shows toast message', (WidgetTester tester) async {
      await _buildRegistrationPage(tester);

      // Enter name
      await tester.enterText(find.byType(TextField).at(0), "John Doe");

      // Enter CNIC
      await tester.enterText(find.byType(TextField).at(1), "12345-6789012-3");

      // Leave phone number empty
      await tester.enterText(find.byType(TextField).at(2), "");

      // Select location
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Lahore").last);
      await tester.pumpAndSettle();

      // Simulate tapping the "Send OTP" button
      await tester.tap(find.text("Send OTP"));
      await tester.pump();

      // Verify that the toast message is shown
      expect(find.text("Fields are empty, please fill all fields"), findsOneWidget);
    });

    testWidgets('Test back button navigates back', (WidgetTester tester) async {
      await _buildRegistrationPage(tester);

      // Simulate tapping the back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Verify that we navigated back
      expect(find.byType(RegistrationPage), findsNothing);
    });
  });
}
