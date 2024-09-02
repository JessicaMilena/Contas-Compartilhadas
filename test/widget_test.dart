import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:contas_compartilhadas/main.dart';

void main() {
  testWidgets('Login screen displays correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the LoginScreen is displayed.
    expect(find.text('Login'), findsOneWidget);
    expect(
        find.byType(TextField),
        findsNWidgets(
            2)); // Assuming there are two text fields on the login screen
    expect(find.byType(ElevatedButton),
        findsOneWidget); // Assuming there is one button on the login screen
  });

  testWidgets('Navigate to RegisterScreen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Tap the "Register" button or navigate to the RegisterScreen if a route is available.
    await tester.tap(find.byType(ElevatedButton));
    await tester
        .pumpAndSettle(); // Wait for the navigation animation to complete

    // Verify that the RegisterScreen is displayed.
    expect(find.text('Register'), findsOneWidget);
  });
}
