// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../components/placeholderArtwork.dart';
import '../components/tabAppBar.dart';
import '../theme.dart';

class AlbumsScreen extends StatelessWidget {
  const AlbumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TabAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Albums',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.onSurface),
            ),
            const SizedBox(height: 16),
            _smartAlbumsGrid(),
            const SizedBox(height: 24),
            Divider(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  'My Albums',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.onSurface),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  color: AppColors.primary,
                  tooltip: 'New album',
                ),
              ],
            ),
            const SizedBox(height: 8),
            _myAlbumsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _smartAlbumsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _albumCard('People', '248 photos', icon: Icons.person, isPeopleGrid: true)),
            const SizedBox(width: 16),
            Expanded(child: _albumCard('Screenshots', '112 items', icon: Icons.screenshot)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _albumCard('Documents', '45 items', icon: Icons.description)),
            const SizedBox(width: 16),
            Expanded(child: _albumCard('Notes', '18 items', icon: Icons.notes)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _albumCard('On This Day', '3 years ago', icon: Icons.calendar_month, imageSeed: 'on-this-day')),
            const SizedBox(width: 16),
            Expanded(child: _albumCard('Trips', '864 photos', icon: Icons.flight, imageSeed: 'trips')),
          ],
        ),
      ],
    );
  }

  Widget _myAlbumsGrid() {
    return Row(
      children: [
        Expanded(child: _albumCard('Summer 2025', '124 items', icon: Icons.beach_access, imageSeed: 'summer-2025')),
        const SizedBox(width: 16),
        Expanded(child: _albumCard('Home Office', '32 items', icon: Icons.home_work, imageSeed: 'home-office')),
      ],
    );
  }

  Widget _albumCard(
    String title,
    String count, {
    required IconData icon,
    bool isPeopleGrid = false,
    String? imageSeed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: 1,
            child: imageSeed != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      PlaceholderArtwork(seed: imageSeed, icon: icon, iconSize: 40),
                      ColoredBox(color: Colors.black.withValues(alpha: 0.25)),
                      Center(child: Icon(icon, size: 32, color: Colors.white)),
                    ],
                  )
                : isPeopleGrid
                    ? _peopleArtwork()
                    : Container(
                        color: AppColors.surfaceContainer,
                        child: Icon(icon, size: 40, color: AppColors.secondary),
                      ),
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(count, style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
      ],
    );
  }

  Widget _peopleArtwork() {
    return Container(
      color: AppColors.surfaceContainer,
      padding: const EdgeInsets.all(4),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var i = 0; i < 4; i++)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: PlaceholderArtwork(seed: 'people-$i', icon: Icons.person, iconSize: 20),
            ),
        ],
      ),
    );
  }
}
