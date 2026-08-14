import 'package:flutter/material.dart';

import '../components/bottomNav.dart';
import '../components/mosaicGrid.dart';
import '../components/neumorphic.dart';
import '../components/photoTile.dart';
import '../theme.dart';
import 'photoDetailScreen.dart';
import 'profileScreen.dart';
import 'searchScreen.dart';

class PersonAlbumScreen extends StatefulWidget {
  const PersonAlbumScreen({super.key, this.personName = 'Sarah Miller'});

  final String personName;

  @override
  State<PersonAlbumScreen> createState() => _PersonAlbumScreenState();
}

class _PersonAlbumScreenState extends State<PersonAlbumScreen> {
  late final String _seed = _slugify(widget.personName);
  late final List<String> _photoSeeds = [
    for (var i = 1; i <= 9; i++) '$_seed-$i',
  ];

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

  void _rename() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Renaming is coming soon.')),
    );
  }

  void _openPhoto() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PhotoDetailScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spans = List.generate(_photoSeeds.length, (_) => const TileSpan(1, 1));

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(top: 92, bottom: 120),
            children: [
              _PersonHeader(
                name: widget.personName,
                seed: _seed,
                onRename: _rename,
              ),
              const SizedBox(height: 32),
              MosaicGrid(
                seeds: _photoSeeds,
                spans: spans,
                radius: 32,
                onPhotoTap: (_) => _openPhoto(),
              ),
            ],
          ),
          Positioned(
            top: 12,
            left: 24,
            right: 24,
            child: _PersonTopBar(
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

class _PersonTopBar extends StatelessWidget {
  const _PersonTopBar({this.onBack, this.onSearch});

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
            _barButton(context, Icons.arrow_back, 'Back', onBack),
            const Spacer(),
            _barButton(context, Icons.search_rounded, 'Search', onSearch),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _barButton(
    BuildContext context,
    IconData icon,
    String tooltip,
    VoidCallback? onTap,
  ) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Neumorphic(
          radius: AppRadii.headerButton,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, size: 20, color: AppColors.onSurface),
          ),
        ),
      ),
    );
  }
}

class _PersonHeader extends StatelessWidget {
  const _PersonHeader({
    required this.name,
    required this.seed,
    required this.onRename,
  });

  final String name;
  final String seed;
  final VoidCallback onRename;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 128,
            height: 128,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
              boxShadow: NeumorphicShadows.convex,
            ),
            child: ClipOval(child: PlaceholderArtwork(seed: seed)),
          ),
          const SizedBox(height: 24),
          Text(
            name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onRename,
            child: Neumorphic(
              radius: 32,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              child: Text(
                'RENAME',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurface,
                      letterSpacing: 1.2,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _slugify(String value) =>
    value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
