import 'package:app/screens/avatar_screen.dart';
import 'package:app/screens/equip_screen.dart';
import 'package:app/screens/team_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/main.dart';

void main() {
  testWidgets("AppFrame tab selection test", (WidgetTester tester) async {

    await tester.pumpWidget(const App());

    expect(find.byType(TeamScreen), findsOneWidget);

    await tester.tap(find.byTooltip("Tasks"));
    await tester.pumpAndSettle();
    expect(find.byType(TeamScreen), findsOneWidget);

    await tester.tap(find.byTooltip("Equip"));
    await tester.pumpAndSettle();
    expect(find.byType(EquipScreen), findsOneWidget);
    
    await tester.tap(find.byTooltip("Avatar"));
    await tester.pumpAndSettle();
    expect(find.byType(AvatarScreen), findsOneWidget);
  });
}
