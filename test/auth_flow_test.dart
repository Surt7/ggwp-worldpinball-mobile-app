import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:world_pinball_gg_wp/src/features/auth/presentation/login_screen.dart';
import 'package:world_pinball_gg_wp/src/features/auth/presentation/screens/register_screen.dart';
import 'package:world_pinball_gg_wp/src/features/auth/presentation/widgets/forgot_password_dialog.dart';

void main() {
  testWidgets('LoginScreen shows forgot password button and opens dialog', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(onLoginSuccess: () {}),
      ),
    );
    await tester.pump();

    // Verify forgot password and register links exist
    final forgotPasswordFinder = find.text('Mot de passe oublié ?');
    final registerFinder = find.text('Créer un compte');

    expect(forgotPasswordFinder, findsOneWidget);
    expect(registerFinder, findsOneWidget);

    // Tap forgot password and verify dialog opens
    await tester.tap(forgotPasswordFinder);
    await tester.pumpAndSettle();

    expect(find.byType(ForgotPasswordDialog), findsOneWidget);
    expect(find.text('RÉINITIALISATION'), findsOneWidget);
  });

  testWidgets('LoginScreen navigates to RegisterScreen when clicking register', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(onLoginSuccess: () {}),
      ),
    );
    await tester.pump();

    // Tap create account link
    final registerFinder = find.text('Créer un compte');
    await tester.tap(registerFinder);
    await tester.pumpAndSettle();

    // Verify RegisterScreen is rendered with inputs
    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(find.text('NOUVEAU JOUEUR - INSCRIPTION'), findsOneWidget);
    expect(find.text('GamerTag / Pseudo'), findsOneWidget);
    expect(find.text('Adresse Email'), findsOneWidget);
    expect(find.text('Confirmer le mot de passe'), findsOneWidget);
    expect(find.text('CRÉER MON COMPTE'), findsOneWidget);
  });
}
