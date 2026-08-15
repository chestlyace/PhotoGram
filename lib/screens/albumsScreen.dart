import 'package:flutter/material.dart';

import '../components/bottomNav.dart';
import '../components/neumorphic.dart';
import '../components/photoTile.dart';
import '../components/topBar.dart';
import '../theme.dart';
import 'peopleScreen.dart';
import 'profileScreen.dart';
import 'searchScreen.dart';
import 'eventMemoryScreen.dart';

class _SmartAlbum {
  const _SmartAlbum(this.title, this.count, this.seed);

  final String title;
  final int count;
  final String seed;
}

class _YourAlbum {
  const _YourAlbum(this.title, this.subtitle, this.seed);

  final String title;
  final String subtitle;
  final String seed;
}

class AlbumsScreen extends StatefulWidget {
  const AlbumsScreen({super.key});

  @override
  State<AlbumsScreen> createState() => _AlbumsScreenState();
}

class _AlbumsScreenState extends State<AlbumsScreen> {
  static const _smartAlbums = [
    _SmartAlbum('People', 124, 'people'),
    _SmartAlbum('Screenshots', 89, 'screenshots'),
    _SmartAlbum('Documents', 42, 'documents'),
    _SmartAlbum('Trips', 15, 'trips'),
  ];

  static const _yourAlbums = [
    _YourAlbum('Summer 2025', 'July 1 - Aug 15 • 312 photos', 'summer'),
    _YourAlbum('Favorites', '48 photos', 'favorites'),
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

  void _onSmartAlbumTap(String title) {
    if (title == 'People') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const PeopleScreen()),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title album is coming soon.')),
    );
  }

  void _onYourAlbumTap(String title) {
    if (title == 'Summer 2025') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const EventMemoryScreen()),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title album is coming soon.')),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle('Smart Albums'),
                    const SizedBox(height: 24),
                    _SmartAlbumGrid(
                      albums: _smartAlbums,
                      onAlbumTap: _onSmartAlbumTap,
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    const _SectionTitle('Your Albums'),
                    const SizedBox(height: 24),
                    _YourAlbumList(
                      albums: _yourAlbums,
                      onAlbumTap: _onYourAlbumTap,
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
            child: PhotogramTopBar(onSearch: _openSearch),
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
    return Text(title, style: Theme.of(context).textTheme.headlineSmall);
  }
}

class _SmartAlbumGrid extends StatelessWidget {
  const _SmartAlbumGrid({required this.albums, required this.onAlbumTap});

  final List<_SmartAlbum> albums;
  final ValueChanged<String> onAlbumTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < albums.length; i += 2) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _SmartAlbumTile(
                  title: albums[i].title,
                  count: albums[i].count,
                  seed: albums[i].seed,
                  onTap: () => onAlbumTap(albums[i].title),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _SmartAlbumTile(
                  title: albums[i + 1].title,
                  count: albums[i + 1].count,
                  seed: albums[i + 1].seed,
                  onTap: () => onAlbumTap(albums[i + 1].title),
                ),
              ),
            ],
          ),
          if (i + 2 < albums.length) const SizedBox(height: 24),
        ],
      ],
    );
  }
}

class _SmartAlbumTile extends StatelessWidget {
  const _SmartAlbumTile({
    required this.title,
    required this.count,
    required this.seed,
    required this.onTap,
  });

  final String title;
  final int count;
  final String seed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Neumorphic(
            radius: 16,
            padding: const EdgeInsets.all(4),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: PlaceholderArtwork(seed: seed),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            '$count items',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _YourAlbumList extends StatelessWidget {
  const _YourAlbumList({required this.albums, required this.onAlbumTap});

  final List<_YourAlbum> albums;
  final ValueChanged<String> onAlbumTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final album in albums) ...[
          _YourAlbumCard(
            title: album.title,
            subtitle: album.subtitle,
            seed: album.seed,
            onTap: () => onAlbumTap(album.title),
          ),
          if (album != albums.last) const SizedBox(height: 24),
        ],
      ],
    );
  }
}

class _YourAlbumCard extends StatelessWidget {
  const _YourAlbumCard({
    required this.title,
    required this.subtitle,
    required this.seed,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String seed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        radius: 32,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 80,
                height: 80,
                child: PlaceholderArtwork(seed: seed),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.chevron_right,
                size: 24,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
