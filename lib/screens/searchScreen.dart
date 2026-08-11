// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../components/chip.dart';
import '../components/placeholderArtwork.dart';
import '../components/tabAppBar.dart';
import '../theme.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TabAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchField(context),
            const SizedBox(height: 16),
            _filterChips(),
            const SizedBox(height: 32),
            const Text(
              'Recent Searches',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.onSurface),
            ),
            const SizedBox(height: 12),
            _recentSearches(),
            const SizedBox(height: 32),
            const Text(
              'Content Types',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.onSurface),
            ),
            const SizedBox(height: 12),
            _contentTypes(),
          ],
        ),
      ),
    );
  }

  Widget _searchField(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search, color: scheme.secondary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              key: const Key('searchField'),
              decoration: const InputDecoration(
                hintText: "Search your photos... 'dog at the beach', 'receipt from March', a person's name",
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              style: const TextStyle(fontSize: 18, color: AppColors.onSurface),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.mic, color: scheme.secondary),
            tooltip: 'Voice search',
          ),
        ],
      ),
    );
  }

  Widget _filterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          FilterChipWidget(label: 'People', icon: Icons.group, selected: true),
          SizedBox(width: 8),
          FilterChipWidget(label: 'Screenshots', icon: Icons.screenshot),
          SizedBox(width: 8),
          FilterChipWidget(label: 'Documents', icon: Icons.description),
          SizedBox(width: 8),
          FilterChipWidget(label: 'Notes', icon: Icons.notes),
          SizedBox(width: 8),
          FilterChipWidget(label: 'Videos', icon: Icons.movie),
        ],
      ),
    );
  }

  Widget _recentSearches() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              const SizedBox(
                height: 160,
                width: double.infinity,
                child: PlaceholderArtwork(seed: 'dog-at-the-beach', icon: Icons.pets, iconSize: 48),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.primary.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                left: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '"dog at the beach"',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    SizedBox(height: 2),
                    Text('Found in Summer 2023', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 120,
                  color: AppColors.surfaceContainerLow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.receipt_long, color: AppColors.primary),
                      const SizedBox(height: 4),
                      const Text('Receipts', style: TextStyle(fontSize: 12, color: AppColors.onSurface)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    const SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: PlaceholderArtwork(seed: 'emma-search', icon: Icons.person, iconSize: 40),
                    ),
                    const Positioned(
                      left: 8,
                      bottom: 8,
                      child: Text('Emma', style: TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _contentTypes() {
    const items = [
      (Icons.article, 'Documents'),
      (Icons.badge, 'ID Cards'),
      (Icons.restaurant_menu, 'Recipes'),
    ];
    return Row(
      children: [
        for (final (icon, label) in items) ...[
          Expanded(
            child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: AppColors.secondaryContainer, shape: BoxShape.circle),
                    child: Icon(icon, size: 20, color: AppColors.onSecondaryContainer),
                  ),
                  const SizedBox(height: 6),
                  Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
