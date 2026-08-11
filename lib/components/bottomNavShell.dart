// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../screens/albumsScreen.dart';
import '../screens/libraryScreen.dart';
import '../screens/profileScreen.dart';
import '../screens/searchScreen.dart';
import '../theme.dart';

class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  static const List<Widget> _tabs = [
    LibraryScreen(),
    SearchScreen(),
    AlbumsScreen(),
    ProfileScreen(),
  ];
  static const List<IconData> _icons = [
    Icons.photo_library,
    Icons.search,
    Icons.auto_stories,
    Icons.person,
  ];
  static const List<String> _labels = ['Library', 'Search', 'Albums', 'Profile'];

  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: _buildNav(),
    );
  }

  Widget _buildNav() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      key: const Key('bottomNav'),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.92),
        border: Border(top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.3))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 72,
          child: Row(
            children: [for (var i = 0; i < 4; i++) _navItem(i)],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index) {
    final selected = index == _index;
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _index = index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _icons[index],
              size: 24,
              fill: selected ? 1 : 0,
              color: selected ? scheme.primary : scheme.secondary,
            ),
            const SizedBox(height: 2),
            Text(
              _labels[index],
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? scheme.primary : scheme.secondary,
              ),
            ),
            Container(
              width: 4,
              height: 4,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: selected ? scheme.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
