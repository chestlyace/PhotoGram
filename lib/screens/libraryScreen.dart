import 'package:flutter/material.dart';

import '../components/bottomNav.dart';
import '../components/mosaicGrid.dart';
import '../components/neumorphic.dart';
import '../components/sectionHeader.dart';
import '../components/topBar.dart';
import '../models/photoAsset.dart';
import '../services/photoLibraryService.dart';
import '../theme.dart';
import '../utils/photoGrouping.dart';
import 'albumsScreen.dart';
import 'photoViewerScreen.dart';
import 'profileScreen.dart';
import 'searchScreen.dart';

enum _LibraryState { loading, denied, empty, ready }

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key, this.service});

  final PhotoLibraryService? service;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with WidgetsBindingObserver {
  late final PhotoLibraryService _service =
      widget.service ?? PhotoLibraryService();

  final _scrollController = ScrollController();
  bool _showFab = true;

  _LibraryState _state = _LibraryState.loading;
  List<PhotoAsset> _photos = const [];
  int _denialCount = 0;
  bool _permanentlyDenied = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) {
        return;
      }
      final visible = _scrollController.offset < 40;
      if (visible != _showFab) {
        setState(() => _showFab = visible);
      }
    });
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _loaded) {
      setState(() => _state = _LibraryState.loading);
      _load();
    }
  }

  Future<void> _load() async {
    final granted = await _service.requestAccess();
    if (!mounted) {
      return;
    }
    if (!granted) {
      _denialCount++;
      setState(() {
        _permanentlyDenied = _denialCount > 1;
        _state = _LibraryState.denied;
      });
      return;
    }
    try {
      final photos = await _service.loadPhotos();
      if (!mounted) {
        return;
      }
      setState(() {
        _photos = photos;
        _loaded = true;
        _state =
            photos.isEmpty ? _LibraryState.empty : _LibraryState.ready;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _state = _LibraryState.empty);
    }
  }

  void _retryPermission() {
    setState(() => _state = _LibraryState.loading);
    _load();
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

  void _openViewer(DaySection section, int index) {
    final start = _photos.indexOf(section.photos.first);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PhotoViewerScreen(
          photos: _photos,
          initialIndex: start + index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_state == _LibraryState.ready)
            ListView(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 92, bottom: 150),
              children: _buildSections(),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 92, bottom: 150),
              child: _buildState(),
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

  List<Widget> _buildSections() {
    final sections = groupPhotosByDay(_photos);
    final children = <Widget>[];
    for (final section in sections) {
      children
        ..add(SectionHeader(
          title: dayLabel(section.day),
          count: section.photos.length,
        ))
        ..add(const SizedBox(height: 12))
        ..add(MosaicGrid(
          seeds: [for (final photo in section.photos) photo.id],
          spans: packedSpans(section.photos.length),
          imageProviders: [for (final photo in section.photos) photo.thumbnail],
          onPhotoTap: (index) => _openViewer(section, index),
        ))
        ..add(const SizedBox(height: AppSpacing.sectionGap));
    }
    return children;
  }

  Widget _buildState() {
    switch (_state) {
      case _LibraryState.loading:
        return Center(
          child: CircularProgressIndicator(color: AppColors.onSurface),
        );
      case _LibraryState.denied:
        return _buildDenied();
      case _LibraryState.empty:
        return _buildEmpty();
      case _LibraryState.ready:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 56,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('Access your photos', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Photogram needs permission to show your photo library.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            _ActionButton(
              label: 'Allow access',
              onTap: _retryPermission,
            ),
            if (_permanentlyDenied) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _service.openSettings(),
                child: const Text('Open Settings'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 56,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text('No photos yet', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Your photo library is empty right now.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.onSurface,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
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
