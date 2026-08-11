import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/components/backAppBar.dart';
import 'package:untitled/components/placeholderAvatar.dart';
import 'package:untitled/components/tabAppBar.dart';
import 'package:untitled/theme.dart';

void main() {
  testWidgets('TabAppBar shows brand and avatar', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const Scaffold(appBar: TabAppBar(), body: SizedBox())));
    expect(find.text('Photogram'), findsOneWidget);
    expect(find.byType(PlaceholderAvatar), findsOneWidget);
  });

  testWidgets('BackAppBar shows back arrow and title', (tester) async {
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: const Scaffold(appBar: BackAppBar(title: 'Upload & Storage'), body: SizedBox())));
    expect(find.text('Upload & Storage'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });
}
