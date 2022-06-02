import 'package:sff/screens/app_frame.dart';
import 'package:sff/screens/pages/avatar_screen.dart';
import 'package:sff/screens/pages/equip_screen.dart';
import 'package:sff/screens/pages/ticket_screen.dart';
import 'package:sff/screens/pages/team_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("AppFrame tab selection test", (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AppFrame()));

    expect(find.byType(TeamScreen), findsOneWidget);

    await tester.tap(find.byTooltip("Tasks"));
    await tester.pumpAndSettle();
    expect(find.byType(TicketScreen), findsOneWidget);

    await tester.tap(find.byTooltip("Equip"));
    await tester.pumpAndSettle();
    expect(find.byType(EquipScreen), findsOneWidget);

    await tester.tap(find.byTooltip("Avatar"));
    await tester.pumpAndSettle();
    expect(find.byType(AvatarScreen), findsOneWidget);
  });
}
