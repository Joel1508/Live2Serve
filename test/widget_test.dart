import 'package:app/Screens/homeScreen/project/bed_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';
import 'package:app/repositories/customer_repository.dart' as model;
import 'package:hive/hive.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Open mock Hive boxes
    final mockCustomerBox = await Hive.openBox('customerBox');
    final mockProjectBox = await Hive.openBox<BedModel>('projectBox');

    // Create mock CustomerRepository
    final mockCustomerRepo =
        model.CustomerRepository(customerBox: mockCustomerBox);

    // Build the app and pass both boxes
    await tester.pumpWidget(MyApp(
      customerRepo: mockCustomerRepo,
      projectBox: mockProjectBox,
    ));

    // Rest of your test...
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
