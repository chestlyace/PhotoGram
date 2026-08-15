import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../components/bottomNav.dart';
import '../components/neumorphic.dart';
import '../components/photoTile.dart';
import '../theme.dart';
import 'personAlbumScreen.dart';
import 'profileScreen.dart';
import 'searchScreen.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  static const _names = ['Elena', 'Marcus', 'Sarah', 'Leo', 'David'];
  static const _unnamedCount = 4;

  /// Person album headers use full names where the design defines them.
  static const _albumNames = <String, String>{'Sarah': 'Sarah Miller'};

  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SearchScreen()),
    );
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
    );
  }

  void _openPerson(String name) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            PersonAlbumScreen(personName: _albumNames[name] ?? name),
      ),
    );
  }

  void _addName() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adding a name is coming soon.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(top: 92, bottom: 120),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerMargin,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle('Named'),
                    const SizedBox(height: 24),
                    _AvatarGrid(
                      items: [
                        for (final name in _names)
                          _PersonTile(name: name, onTap: () => _openPerson(name)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    const _SectionTitle('Add names'),
                    const SizedBox(height: 24),
                    _AvatarGrid(
                      items: [
                        for (var i = 0; i < _unnamedCount; i++)
                          _PersonTile(
                            name: 'unnamed-$i',
                            faded: true,
                            onTap: _addName,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 12,
            left: 24,
            right: 24,
            child: _PeopleTopBar(
              onBack: () => Navigator.of(context).pop(),
              onSearch: _openSearch,
            ),
          ),
          Positioned(
            bottom: 12,
            left: 24,
            right: 24,
            child: PhotogramNav(
              selected: PhotogramTab.albums,
              onSelect: (tab) {
                switch (tab) {
                  case PhotogramTab.library:
                    Navigator.of(context).pop();
                  case PhotogramTab.search:
                    _openSearch();
                  case PhotogramTab.albums:
                    break;
                  case PhotogramTab.profile:
                    _openProfile();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}

class _PeopleTopBar extends StatelessWidget {
  const _PeopleTopBar({this.onBack, this.onSearch});

  final VoidCallback? onBack;
  final VoidCallback? onSearch;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      radius: AppRadii.headerPill,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            const SizedBox(width: 16),
            Tooltip(
              message: 'Back',
              child: GestureDetector(
                onTap: onBack,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                'People',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Tooltip(
              message: 'Search',
              child: GestureDetector(
                onTap: onSearch,
                child: Neumorphic(
                  radius: AppRadii.headerButton,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _AvatarGrid extends StatelessWidget {
  const _AvatarGrid({required this.items});

  static const _columns = 3;
  static const _gap = 24.0;

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth =
            (constraints.maxWidth - _gap * (_columns - 1)) / _columns;
        final rows = <List<Widget>>[];
        for (var i = 0; i < items.length; i += _columns) {
          rows.add(items.sublist(i, math.min(i + _columns, items.length)));
        }
        return Column(
          children: [
            for (var r = 0; r < rows.length; r++) ...[
              _row(rows[r], cellWidth),
              if (r + 1 < rows.length) const SizedBox(height: 24),
            ],
          ],
        );
      },
    );
  }

  Widget _row(List<Widget> cells, double cellWidth) {
    if (cells.length == _columns) {
      return Row(
        children: [
          for (var i = 0; i < cells.length; i++) ...[
            if (i > 0) const SizedBox(width: _gap),
            Expanded(child: cells[i]),
          ],
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < cells.length; i++) ...[
          if (i > 0) const SizedBox(width: _gap),
          SizedBox(width: cellWidth, child: cells[i]),
        ],
      ],
    );
  }
}

class _PersonTile extends StatelessWidget {
  const _PersonTile({
    required this.name,
    required this.onTap,
    this.faded = false,
  });

  final String name;
  final VoidCallback onTap;
  final bool faded;

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: 80,
      height: 80,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        shape: BoxShape.circle,
        boxShadow: NeumorphicShadows.convex,
      ),
      child: ClipOval(
        child: faded
            ? ColorFiltered(
                colorFilter: const ColorFilter.matrix(_fadedMatrix),
                child: PlaceholderArtwork(seed: name),
              )
            : PlaceholderArtwork(seed: name),
      ),
    );

    final label = faded
        ? Neumorphic(
            radius: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              'ADD NAME',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
            ),
          )
        : Text(name, style: Theme.of(context).textTheme.bodySmall);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          avatar,
          const SizedBox(height: 12),
          label,
        ],
      ),
    );
  }
}

/// Desaturates and slightly brightens artwork to read as an unidentified face.
const _fadedMatrix = <double>[
  0.61, 0.32, 0.06, 0, 20,
  0.61, 0.32, 0.06, 0, 20,
  0.61, 0.32, 0.06, 0, 20,
  0, 0, 0, 1, 0,
];
