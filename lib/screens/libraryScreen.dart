// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../components/photoTile.dart';
import '../components/sectionHeader.dart';
import '../components/tabAppBar.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static const List<String> _todaySeeds = ['today-1', 'today-2', 'today-3'];
  static const List<String> _marchSeeds = [
    'march-1',
    'march-2',
    'march-3',
    'march-4',
    'march-5',
    'march-6',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TabAppBar(),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          const StickySectionHeader(title: 'Today'),
          _photoGrid(context, _todaySeeds, selectedIndex: 0),
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
          const StickySectionHeader(title: 'March 2026'),
          _photoGrid(context, _marchSeeds),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/settings'),
        tooltip: 'Upload photo',
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _photoGrid(BuildContext context, List<String> seeds, {int? selectedIndex}) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return PhotoTile(
              seed: seeds[index],
              selected: index == selectedIndex,
              onTap: () => Navigator.of(context).pushNamed('/photo'),
            );
          },
          childCount: seeds.length,
        ),
      ),
    );
  }
}
