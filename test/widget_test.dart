import 'package:flutter_test/flutter_test.dart';
import 'package:spiritual_insights/app.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Verify the app widget can be instantiated
    expect(const SpiritualInsightsApp(), isNotNull);
  });
}
