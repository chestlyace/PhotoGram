import 'package:flutter_test/flutter_test.dart';

import 'package:photogram/main.dart';

import 'helpers.dart';

void main() {
  testWidgets('app boots into the Library screen', (tester) async {
    setPhoneSurface(tester);
    await tester.pumpWidget(const PhotogramApp());
    await tester.pumpAndSettle();

    expect(find.text('Photogram'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
  });
}
