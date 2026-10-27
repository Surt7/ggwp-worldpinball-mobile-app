import 'package:flutter_test/flutter_test.dart';
import 'package:world_pinball_gg_wp/main.dart';

void main() {
  testWidgets('World Pinball App boots and renders tabs smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Verify navigation tabs are present
    expect(find.text('World Pinball'), findsOneWidget);
    expect(find.text('Scores'), findsOneWidget);
    expect(find.text('Machines'), findsOneWidget);
    expect(find.text('Leaderboard'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}
