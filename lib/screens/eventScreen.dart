// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../components/backAppBar.dart';
import '../components/placeholderArtwork.dart';
import '../theme.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert),
          color: AppColors.primary,
          tooltip: 'More',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openShareSheet(context),
        tooltip: 'Share memory',
        child: const Icon(Icons.ios_share),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        child: Column(
          children: [
            _cover(),
            const SizedBox(height: 16),
            const Text(
              'Summer 2025',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            const Text('July 15 - 22', style: TextStyle(fontSize: 16, color: AppColors.secondary)),
            const SizedBox(height: 12),
            _tagChips(),
            const SizedBox(height: 32),
            const Text(
              'Memory Highlights',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            _highlights(),
            const SizedBox(height: 32),
            const Text(
              'All Photos (142)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            _photoGrid(),
          ],
        ),
      ),
    );
  }

  Widget _cover() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: const SizedBox(
        height: 288,
        width: double.infinity,
        child: PlaceholderArtwork(seed: 'event-cover', icon: Icons.beach_access, iconSize: 72),
      ),
    );
  }

  Widget _tagChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final tag in const ['Malibu', 'Beach', 'Family']) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              tag,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }

  Widget _highlights() {
    return SizedBox(
      height: 256,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _highlightTile('highlight-1', Icons.local_drink, showPlay: false),
          const SizedBox(width: 12),
          _highlightTile('highlight-2', Icons.pets, showPlay: true),
          const SizedBox(width: 12),
          _highlightTile('highlight-3', Icons.local_fire_department, showPlay: false),
        ],
      ),
    );
  }

  Widget _highlightTile(String seed, IconData icon, {required bool showPlay}) {
    return SizedBox(
      width: 192,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PlaceholderArtwork(seed: seed, icon: icon, iconSize: 48),
            if (showPlay)
              Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow, color: AppColors.primary),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _photoGrid() {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: const AspectRatio(
              aspectRatio: 1,
              child: PlaceholderArtwork(seed: 'grid-1', icon: Icons.wb_sunny_outlined),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: const AspectRatio(
              aspectRatio: 1,
              child: PlaceholderArtwork(seed: 'grid-2', icon: Icons.umbrella_outlined),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: AppColors.surfaceContainerHigh,
              alignment: Alignment.center,
              child: const Text(
                '+139',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.secondary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openShareSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white.withValues(alpha: 0.92),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(999)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Share Memory',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ShareOption(icon: Icons.groups, label: 'Photogram'),
                  _ShareOption(icon: Icons.send, label: 'Telegram'),
                  _ShareOption(icon: Icons.chat, label: 'WhatsApp'),
                  _ShareOption(icon: Icons.mail, label: 'Email'),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainerHigh,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShareOption extends StatelessWidget {
  const _ShareOption({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceVariant),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondary)),
      ],
    );
  }
}
