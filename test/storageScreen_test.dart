import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:photogram/screens/profileScreen.dart';
import 'package:photogram/screens/storageScreen.dart';
import 'package:photogram/theme.dart';

import 'helpers.dart';

void main() {
  Future<void> pumpStorage(WidgetTester tester) async {
    setPhoneSurface(tester, const Size(402, 1600));
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: const StorageScreen()),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders the storage management layout', (tester) async {
    await pumpStorage(tester);

    expect(find.text('Storage'), findsOneWidget);
    expect(find.text('Current storage'), findsOneWidget);
    expect(find.text('Storage settings'), findsOneWidget);
    expect(find.text('About storage'), findsOneWidget);

    expect(find.text('Photogram storage'), findsNWidgets(2));
    expect(find.text('Active'), findsOneWidget);
    expect(
      find.text('Your photos and videos are securely stored with Photogram.'),
      findsOneWidget,
    );
    expect(find.text('2.4 GB of 10 GB used'), findsOneWidget);
    expect(find.text('Manage'), findsOneWidget);

    expect(find.text('Recommended for automatic backup'), findsOneWidget);
    expect(find.text('My storage'), findsOneWidget);
    expect(find.text('Use a storage destination you manage'), findsOneWidget);
    expect(find.text('Add storage'), findsOneWidget);
    expect(
      find.text(
        'Choose where Photogram keeps your photos and videos. You can change '
        'storage settings later without changing your Photogram library.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Photogram keeps your library organization (albums, tags, and favorites) '
        'saved securely to your account, regardless of where your actual photo '
        'and video files are stored.',
      ),
      findsOneWidget,
    );

    expect(find.byTooltip('Library'), findsOneWidget);
    expect(find.byTooltip('Profile'), findsOneWidget);
  });

  testWidgets('Manage button shows a placeholder snackbar', (tester) async {
    await pumpStorage(tester);

    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();

    expect(find.text('Storage management is coming soon.'), findsOneWidget);
  });

  testWidgets('Add storage shows a placeholder snackbar', (tester) async {
    await pumpStorage(tester);

    await tester.tap(find.text('Add storage'));
    await tester.pumpAndSettle();

    expect(find.text('Adding storage is coming soon.'), findsOneWidget);
  });

  testWidgets('storage destination rows show placeholder snackbars',
      (tester) async {
    await pumpStorage(tester);

    await tester.tap(find.text('My storage'));
    await tester.pumpAndSettle();
    expect(find.text('Switching storage is coming soon.'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Photogram storage').last);
    await tester.pumpAndSettle();
    expect(find.text('Switching storage is coming soon.'), findsOneWidget);
  });

  testWidgets('back button pops to the previous screen', (tester) async {
    setPhoneSurface(tester);
    await tester.pumpWidget(
      MaterialApp(theme: buildAppTheme(), home: const ProfileScreen()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    expect(find.byType(StorageScreen), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    expect(find.byType(StorageScreen), findsNothing);
    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}
