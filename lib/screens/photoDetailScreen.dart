import 'package:flutter/material.dart';

import '../components/neumorphic.dart';
import '../components/photoTile.dart';
import '../theme.dart';
import 'personAlbumScreen.dart';

class PhotoDetailScreen extends StatelessWidget {
  const PhotoDetailScreen({super.key});

  static const _people = [
    ('Sarah M.', 'sarah-m', 'Sarah Miller'),
    ('David K.', 'david-k', 'David'),
  ];

  void _placeholder(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _openPerson(BuildContext context, String albumName) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PersonAlbumScreen(personName: albumName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: LandscapePhoto(seed: 'detail'),
          ),
          Positioned(
            top: 48,
            left: AppSpacing.containerMargin,
            child: _barButton(
              context,
              Icons.arrow_back,
              'Back',
              () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _DetailSheet(
              onShare: () => _placeholder(context, 'Sharing is coming soon.'),
              onOpenPerson: (albumName) => _openPerson(context, albumName),
              onAlbumTap: (album) =>
                  _placeholder(context, '$album album is coming soon.'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _barButton(
    BuildContext context,
    IconData icon,
    String tooltip,
    VoidCallback onTap,
  ) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Neumorphic(
          radius: 24,
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(icon, size: 22, color: AppColors.onSurface),
          ),
        ),
      ),
    );
  }
}

class _DetailSheet extends StatelessWidget {
  const _DetailSheet({
    required this.onShare,
    required this.onOpenPerson,
    required this.onAlbumTap,
  });

  final VoidCallback onShare;
  final ValueChanged<String> onOpenPerson;
  final ValueChanged<String> onAlbumTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.4),
            offset: Offset(0, -8),
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            Neumorphic(
              variant: NeumorphicVariant.concave,
              radius: 3,
              color: AppColors.outlineVariant,
              child: const SizedBox(width: 48, height: 6),
            ),
            const SizedBox(height: 24),
            _HeaderRow(onShare: onShare),
            const SizedBox(height: 24),
            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0x4DC4C7C9),
            ),
            const SizedBox(height: 24),
            _SectionLabel('In this photo'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final person in PhotoDetailScreen._people)
                  _PersonChip(
                    name: person.$1,
                    seed: person.$2,
                    onTap: () => onOpenPerson(person.$3),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            _SectionLabel('Albums'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _SolidPill(
                  label: 'Summer 2025',
                  onTap: () => onAlbumTap('Summer 2025'),
                ),
                _ConvexPill(
                  label: 'Favorites',
                  icon: Icons.favorite,
                  onTap: () => onAlbumTap('Favorites'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                _MetaItem(Icons.location_on_outlined, 'Yosemite Valley'),
                _MetaItem(Icons.photo_camera_outlined, 'Sony A7IV'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.onShare});

  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CAPTURED',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'October 14, 2024',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        Tooltip(
          message: 'Share',
          child: GestureDetector(
            onTap: onShare,
            child: Neumorphic(
              radius: 24,
              child: SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  Icons.share,
                  size: 22,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context)
          .textTheme
          .labelMedium
          ?.copyWith(color: AppColors.onSurfaceVariant),
    );
  }
}

class _PersonChip extends StatelessWidget {
  const _PersonChip({
    required this.name,
    required this.seed,
    required this.onTap,
  });

  final String name;
  final String seed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        radius: 32,
        padding: const EdgeInsets.only(left: 6, right: 16, top: 6, bottom: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipOval(
              child: SizedBox(
                width: 32,
                height: 32,
                child: PlaceholderArtwork(seed: seed),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SolidPill extends StatelessWidget {
  const _SolidPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

class _ConvexPill extends StatelessWidget {
  const _ConvexPill({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        radius: 32,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.onSurface),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem(this.icon, this.label);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
