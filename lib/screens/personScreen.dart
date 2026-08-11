// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../components/placeholderAvatar.dart';
import '../components/photoTile.dart';
import '../components/sectionHeader.dart';
import '../theme.dart';

class PersonScreen extends StatelessWidget {
  const PersonScreen({super.key});

  static const List<String> _recentSeeds = ['recent-1', 'recent-2', 'recent-3', 'recent-4'];
  static const List<String> _lastSummerSeeds = ['summer-1', 'summer-2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _header(context)),
          const StickySectionHeader(title: 'Recent'),
          _grid(context, _recentSeeds),
          const SliverToBoxAdapter(child: SizedBox(height: 28)),
          const StickySectionHeader(title: 'Last Summer'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AspectRatio(
                aspectRatio: 2 / 1,
                child: PhotoTile(
                  seed: 'last-summer-wide',
                  onTap: () => Navigator.of(context).pushNamed('/photo'),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 4)),
          _grid(context, _lastSummerSeeds),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back),
                color: AppColors.onSurface,
                tooltip: 'Back',
              ),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 8),
          const PlaceholderAvatar(seed: 'emma', size: 128),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Emma',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.w600, color: AppColors.onSurface),
              ),
              SizedBox(width: 8),
              Icon(Icons.edit, size: 18, color: AppColors.secondary),
            ],
          ),
          const SizedBox(height: 8),
          const Text('42 Photos', style: TextStyle(fontSize: 16, color: AppColors.secondary)),
        ],
      ),
    );
  }

  Widget _grid(BuildContext context, List<String> seeds) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => PhotoTile(
            seed: seeds[index],
            onTap: () => Navigator.of(context).pushNamed('/photo'),
          ),
          childCount: seeds.length,
        ),
      ),
    );
  }
}
