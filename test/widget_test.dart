import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';
import 'package:app/repositories/customer_repository.dart' as model;
import 'package:hive/hive.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Create a mock CustomerRepository
    final mockBox = await Hive.openBox('customerBox');
    final mockCustomerRepo = model.CustomerRepository(customerBox: mockBox);

    // Build our app and trigger a frame with the mock repository
    await tester.pumpWidget(MyApp(customerRepo: mockCustomerRepo));

    // Rest of your test...
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
