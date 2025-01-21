import 'package:app/Screens/homeScreen/customers/models/customer_model.dart';
import 'package:app/Screens/homeScreen/invoice/models/invoice_model.dart';
import 'package:app/Screens/homeScreen/project/bed_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';
import 'package:app/repositories/customer_repository.dart' as model;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

import 'mock_hive_box.mocks.dart';

void main() {
  setUpAll(() async {
    // Initialize Hive with a temporary directory
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);

    // Register adapters for custom models
    Hive.registerAdapter(CustomerModelAdapter());
    Hive.registerAdapter(BedModelAdapter());
  });

  tearDownAll(() async {
    // Clean up Hive and delete all boxes after tests
    await Hive.deleteFromDisk();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Open mock Hive boxes
    final mockCustomerBox = await Hive.openBox<CustomerModel>('customerBox');
    final mockProjectBox = await Hive.openBox<BedModel>('projectBox');

    // Create mock CustomerRepository
    final mockCustomerRepo =
        model.CustomerRepository(customerBox: mockCustomerBox);

    // Create mock InvoiceBox
    final mockInvoiceBox = MockBox<Invoice>();

    // Build the app and pass the boxes
    await tester.pumpWidget(MyApp(
      customerRepo: mockCustomerRepo,
      projectBox: mockProjectBox,
      invoiceBox: mockInvoiceBox,
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
