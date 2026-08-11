// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../components/placeholderArtwork.dart';
import '../theme.dart';

class PhotoDetailScreen extends StatelessWidget {
  const PhotoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const PlaceholderArtwork(seed: 'photo-detail', icon: Icons.photo_outlined, iconSize: 120),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _topBar(context),
                const SizedBox(height: 32),
                const Expanded(child: SizedBox()),
                _bottomPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _roundButton(Icons.arrow_back, () => Navigator.of(context).maybePop(), 'Go back'),
          Row(
            children: [
              _roundButton(Icons.favorite, () {}, 'Favorite'),
              const SizedBox(width: 12),
              _roundButton(Icons.ios_share, () {}, 'Share'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundButton(IconData icon, VoidCallback onTap, String tooltip) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.2), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _bottomPanel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'October 24, 2023',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.white70),
              SizedBox(width: 4),
              Text('Mount Rainier National Park', style: TextStyle(fontSize: 16, color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('PEOPLE', style: TextStyle(fontSize: 12, letterSpacing: 1.2, color: Colors.white70)),
          const SizedBox(height: 8),
          const Row(
            children: [
              _PersonChip(name: 'Sarah', seed: 'chip-sarah'),
              SizedBox(width: 8),
              _PersonChip(name: 'David', seed: 'chip-david'),
            ],
          ),
          const SizedBox(height: 16),
          const Text('DETAILS', style: TextStyle(fontSize: 12, letterSpacing: 1.2, color: Colors.white70)),
          const SizedBox(height: 8),
          const _DetailChip(icon: Icons.photo_album, label: 'Pacific Northwest Trip'),
          const SizedBox(height: 8),
          const _DetailChip(icon: Icons.camera, label: 'Sony A7IV • 35mm'),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < 4; i++)
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i == 1 ? Colors.white : Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PersonChip extends StatelessWidget {
  const _PersonChip({required this.name, required this.seed});

  final String name;
  final String seed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: SizedBox(
              width: 24,
              height: 24,
              child: PlaceholderArtwork(seed: seed, icon: Icons.person, iconSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.white)),
        ],
      ),
    );
  }
}
