import 'package:flutter/material.dart';

import '../components/bottomNav.dart';
import '../components/mosaicGrid.dart';
import '../components/neumorphic.dart';
import '../components/sectionHeader.dart';
import '../components/topBar.dart';
import '../theme.dart';
import 'albumsScreen.dart';
import 'photoDetailScreen.dart';
import 'profileScreen.dart';
import 'searchScreen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  static const _todaySeeds = ['violet', 'dawn', 'amber', 'mist', 'jade'];
  static const _marchSeeds = [
    'aurora',
    'ember',
    'cobalt',
    'fern',
    'orchid',
    'pearl',
  ];

  static const _todaySpans = [
    TileSpan(1, 1),
    TileSpan(1, 1),
    TileSpan(1, 1),
    TileSpan(1, 1),
    TileSpan(1, 1),
  ];

  static const _marchSpans = [
    TileSpan(1, 1),
    TileSpan(1, 1),
    TileSpan(1, 1),
    TileSpan(1, 1),
    TileSpan(1, 1),
    TileSpan(1, 1),
  ];

  final _scrollController = ScrollController();
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) {
        return;
      }
      final visible = _scrollController.offset < 40;
      if (visible != _showFab) {
        setState(() => _showFab = visible);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleAdd() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import is coming soon.')),
    );
  }

  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SearchScreen()),
    );
  }

  void _openAlbums() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const AlbumsScreen()),
    );
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
    );
  }

  void _openPhoto() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PhotoDetailScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 92, bottom: 150),
            children: [
              const SectionHeader(title: 'Today', count: 5),
              const SizedBox(height: 12),
              MosaicGrid(
                seeds: _todaySeeds,
                spans: _todaySpans,
                onPhotoTap: (_) => _openPhoto(),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              const SectionHeader(title: 'March 2026', count: 6),
              const SizedBox(height: 12),
              MosaicGrid(
                seeds: _marchSeeds,
                spans: _marchSpans,
                onPhotoTap: (_) => _openPhoto(),
              ),
            ],
          ),
          Positioned(
            top: 12,
            left: 24,
            right: 24,
            child: PhotogramTopBar(onSearch: _openSearch),
          ),
          Positioned(
            right: 24,
            bottom: 96,
            child: AnimatedOpacity(
              opacity: _showFab ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              child: _AddButton(onPressed: _handleAdd),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 24,
            right: 24,
            child: PhotogramNav(
              selected: PhotogramTab.library,
              onSelect: (tab) {
                switch (tab) {
                  case PhotogramTab.library:
                    break;
                  case PhotogramTab.profile:
                    _openProfile();
                  case PhotogramTab.search:
                    _openSearch();
                  case PhotogramTab.albums:
                    _openAlbums();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Add photos',
      child: GestureDetector(
        onTap: onPressed,
        child: Neumorphic(
          radius: 32,
          child: SizedBox(
            width: 64,
            height: 64,
            child: Icon(Icons.add_rounded, size: 28, color: AppColors.onSurface),
          ),
        ),
      ),
    );
  }
}
