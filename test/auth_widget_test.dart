import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zenup_health/features/auth/presentation/login_screen.dart';
import 'package:zenup_health/features/auth/presentation/signup_screen.dart';
import 'package:zenup_health/features/auth/presentation/widgets/auth_widgets.dart';

void main() {
  testWidgets('LoginScreen Email/Phone Switcher Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    // Initial state: should show email field and not phone field
    expect(find.byKey(const ValueKey('email_field')), findsOneWidget);
    expect(find.byKey(const ValueKey('phone_field')), findsNothing);

    // Tap on the 'phone number' selector tab
    await tester.tap(find.text('phone number'));
    await tester.pumpAndSettle();

    // After switching: should show phone field and not email field
    expect(find.byKey(const ValueKey('phone_field')), findsOneWidget);
    expect(find.byKey(const ValueKey('email_field')), findsNothing);

    // Tap back to 'email address' selector tab
    await tester.tap(find.text('email address'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('email_field')), findsOneWidget);
    expect(find.byKey(const ValueKey('phone_field')), findsNothing);
  });

  testWidgets('SignupScreen renders email and phone fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SignupScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // SignupScreen displays all fields together
    expect(find.text('your email'), findsOneWidget);
    expect(find.text('your phone number'), findsOneWidget);
    expect(find.text('create a password'), findsOneWidget);
  });
}
