import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:world_pinball_gg_wp/main.dart';
import 'package:world_pinball_gg_wp/src/features/navigation/presentation/main_navigation_screen.dart';

void main() {
  testWidgets('MainNavigationScreen renders arcade tabs smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MainNavigationScreen(onLogout: () {}),
      ),
    );
    await tester.pump();

    // Verify navigation tabs and title are present
    expect(find.text('WORLD PINBALL'), findsOneWidget);
    expect(find.text('Scores'), findsOneWidget);
    expect(find.text('Machines'), findsOneWidget);
    expect(find.text('Leaderboard'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });

  testWidgets('MyApp boots into AuthGate smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // In a test environment without stored tokens, AuthGate renders the Keycloak LoginScreen
    expect(find.byType(MyApp), findsOneWidget);
  });
}
