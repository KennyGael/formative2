import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_incident_app/widgets/category_selector.dart';
import 'package:campus_incident_app/widgets/status_chip.dart';

void main() {
  testWidgets('StatusChip shows the right label', (tester) async {
    await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: StatusChip(status: 'resolved'))));
    expect(find.text('Resolved'), findsOneWidget);
  });

  testWidgets('CategorySelector reports the tapped category', (tester) async {
    String? picked;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CategorySelector(selected: null, onChanged: (c) => picked = c),
      ),
    ));
    await tester.tap(find.text('Water'));
    expect(picked, 'water');
  });
}
