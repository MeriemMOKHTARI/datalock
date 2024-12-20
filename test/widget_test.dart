/*************  ✨ Codeium Command ⭐  *************/
/******  3d9d730c-9887-4221-86f9-530300712a91  *******/  /// A smoke test that verifies the `MyApp` widget's counter works.

  ///

  /// This test verifies that the counter starts at 0, increments by 1 when

  /// the "+" icon is tapped, and displays the new value correctly.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appwrite/appwrite.dart'; // Import Appwrite SDK for Account, Databases, and Functions.
import 'package:datalock/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Mock objects for Appwrite services.
    final mockAccount = Account(Client());
    final mockDatabases = Databases(Client());
    final mockFunctions = Functions(Client());

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      account: mockAccount,
      databases: mockDatabases,
      functions: mockFunctions,
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
