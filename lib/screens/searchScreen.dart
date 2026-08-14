import 'package:flutter/material.dart';

import '../components/bottomNav.dart';
import '../components/filterPill.dart';
import '../components/mosaicGrid.dart';
import '../components/sectionHeader.dart';
import '../components/topBar.dart';
import '../theme.dart';
import 'albumsScreen.dart';
import 'photoDetailScreen.dart';
import 'profileScreen.dart';

enum SearchFilter { people, screenshots, documents, notes, videos }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _seeds = [
    'violet',
    'dawn',
    'amber',
    'mist',
    'jade',
    'aurora',
    'ember',
    'cobalt',
    'fern',
    'orchid',
    'pearl',
  ];

  static const _categories = <String, SearchFilter>{
    'violet': SearchFilter.people,
    'orchid': SearchFilter.people,
    'dawn': SearchFilter.documents,
    'pearl': SearchFilter.documents,
    'amber': SearchFilter.notes,
    'ember': SearchFilter.notes,
    'fern': SearchFilter.notes,
    'mist': SearchFilter.screenshots,
    'jade': SearchFilter.screenshots,
    'aurora': SearchFilter.videos,
    'cobalt': SearchFilter.videos,
  };

  static const _gridRadius = 32.0;

  String _query = '';
  SearchFilter? _filter;

  void _openPhoto() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PhotoDetailScreen()),
    );
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
    );
  }

  void _openAlbums() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const AlbumsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final filtered = _seeds
        .where((seed) =>
            seed.contains(query) &&
            (_filter == null || _categories[seed] == _filter))
        .toList();
    final spans = List.generate(filtered.length, (_) => const TileSpan(1, 1));

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(top: 92, bottom: 120),
            children: [
              _FilterRow(
                selected: _filter,
                onSelected: (filter) => setState(() => _filter = filter),
              ),
              const SizedBox(height: 24),
              SectionHeader(title: 'Recent', count: filtered.length),
              const SizedBox(height: 12),
              if (filtered.isEmpty)
                const _EmptyState()
              else
                MosaicGrid(
                  seeds: filtered,
                  spans: spans,
                  radius: _gridRadius,
                  onPhotoTap: (_) => _openPhoto(),
                ),
            ],
          ),
          Positioned(
            top: 12,
            left: 24,
            right: 24,
            child: PhotogramSearchBar(onChanged: (value) {
              setState(() => _query = value);
            }),
          ),
          Positioned(
            bottom: 12,
            left: 24,
            right: 24,
            child: PhotogramNav(
              selected: PhotogramTab.search,
              onSelect: (tab) {
                switch (tab) {
                  case PhotogramTab.library:
                    Navigator.of(context).pop();
                  case PhotogramTab.search:
                    break;
                  case PhotogramTab.albums:
                    _openAlbums();
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

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.selected, required this.onSelected});

  final SearchFilter? selected;
  final ValueChanged<SearchFilter?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        children: [
          FilterPill(
            label: 'People',
            selected: selected == SearchFilter.people,
            onTap: () => onSelected(
              selected == SearchFilter.people ? null : SearchFilter.people,
            ),
          ),
          const SizedBox(width: 16),
          FilterPill(
            label: 'Screenshots',
            selected: selected == SearchFilter.screenshots,
            onTap: () => onSelected(
              selected == SearchFilter.screenshots
                  ? null
                  : SearchFilter.screenshots,
            ),
          ),
          const SizedBox(width: 16),
          FilterPill(
            label: 'Documents',
            selected: selected == SearchFilter.documents,
            onTap: () => onSelected(
              selected == SearchFilter.documents
                  ? null
                  : SearchFilter.documents,
            ),
          ),
          const SizedBox(width: 16),
          FilterPill(
            label: 'Notes',
            selected: selected == SearchFilter.notes,
            onTap: () => onSelected(
              selected == SearchFilter.notes ? null : SearchFilter.notes,
            ),
          ),
          const SizedBox(width: 16),
          FilterPill(
            label: 'Videos',
            selected: selected == SearchFilter.videos,
            onTap: () => onSelected(
              selected == SearchFilter.videos ? null : SearchFilter.videos,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(
          'No photos match your search',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ),
    );
  }
}
