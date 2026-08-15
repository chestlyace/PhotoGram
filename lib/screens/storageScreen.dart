import 'package:flutter/material.dart';

import '../components/bottomNav.dart';
import '../components/neumorphic.dart';
import '../theme.dart';
import 'albumsScreen.dart';
import 'searchScreen.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  void _comingSoon(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _openSearch(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SearchScreen()),
    );
  }

  void _openAlbums(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const AlbumsScreen()),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.containerMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle('Current storage'),
                    const SizedBox(height: 24),
                    _CurrentStorageCard(
                      onManage: () =>
                          _comingSoon(context, 'Storage management is coming soon.'),
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    const _SectionTitle('Storage settings'),
                    const SizedBox(height: 24),
                    _StorageOptionRow(
                      icon: Icons.cloud_done_outlined,
                      title: 'Photogram storage',
                      subtitle: 'Recommended for automatic backup',
                      onTap: () => _comingSoon(
                        context,
                        'Switching storage is coming soon.',
                      ),
                    ),
                    const SizedBox(height: 24),
                    _StorageOptionRow(
                      icon: Icons.folder_outlined,
                      title: 'My storage',
                      subtitle: 'Use a storage destination you manage',
                      onTap: () => _comingSoon(
                        context,
                        'Switching storage is coming soon.',
                      ),
                    ),
                    const SizedBox(height: 24),
                    _AddStorageButton(
                      onTap: () =>
                          _comingSoon(context, 'Adding storage is coming soon.'),
                    ),
                    const SizedBox(height: 16),
                    const _Caption(
                      'Choose where Photogram keeps your photos and videos. You can change storage settings later without changing your Photogram library.',
                    ),
                    const SizedBox(height: AppSpacing.sectionGap),
                    const _SectionTitle('About storage'),
                    const SizedBox(height: 24),
                    const _Caption(
                      'Photogram keeps your library organization (albums, tags, and favorites) saved securely to your account, regardless of where your actual photo and video files are stored.',
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
            child: _StorageTopBar(
              onBack: () => Navigator.of(context).pop(),
              onMore: () => _comingSoon(context, 'More options are coming soon.'),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 24,
            right: 24,
            child: PhotogramNav(
              selected: PhotogramTab.profile,
              onSelect: (tab) {
                switch (tab) {
                  case PhotogramTab.library:
                    Navigator.of(context).pop();
                  case PhotogramTab.search:
                    _openSearch(context);
                  case PhotogramTab.albums:
                    _openAlbums(context);
                  case PhotogramTab.profile:
                    Navigator.of(context).pop();
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

class _Caption extends StatelessWidget {
  const _Caption(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: AppColors.onSurfaceVariant, height: 1.43),
    );
  }
}

class _CurrentStorageCard extends StatelessWidget {
  const _CurrentStorageCard({required this.onManage});

  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      radius: AppRadii.card,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Neumorphic(
                variant: NeumorphicVariant.concave,
                radius: 20,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(Icons.cloud, size: 20, color: AppColors.onSurfaceVariant),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Photogram storage',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    const _ActiveChip(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Your photos and videos are securely stored with Photogram.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          const _StorageBar(fraction: 0.24),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  '2.4 GB of 10 GB used',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ),
              _ManageButton(onTap: onManage),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  const _ActiveChip();

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      variant: NeumorphicVariant.concave,
      radius: 20,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF34A853),
            ),
            child: SizedBox(width: 8, height: 8),
          ),
          const SizedBox(width: 6),
          Text(
            'Active',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _StorageBar extends StatelessWidget {
  const _StorageBar({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12,
      child: Stack(
        children: [
          Positioned.fill(
            child: Neumorphic(
              variant: NeumorphicVariant.concave,
              color: AppColors.surfaceContainerHighest,
              radius: 6,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 12,
              child: FractionallySizedBox(
                widthFactor: fraction,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.outline,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ManageButton extends StatelessWidget {
  const _ManageButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        radius: 32,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text(
          'Manage',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _StorageOptionRow extends StatelessWidget {
  const _StorageOptionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        radius: 20,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Neumorphic(
              variant: NeumorphicVariant.concave,
              radius: 20,
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
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
            Icon(
              Icons.chevron_right,
              size: 24,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddStorageButton extends StatelessWidget {
  const _AddStorageButton({required this.onTap});

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
            Icon(Icons.add, size: 18, color: AppColors.onSurface),
            const SizedBox(width: 8),
            Text(
              'Add storage',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _StorageTopBar extends StatelessWidget {
  const _StorageTopBar({this.onBack, this.onMore});

  final VoidCallback? onBack;
  final VoidCallback? onMore;

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
            Text('Storage', style: Theme.of(context).textTheme.headlineMedium),
            const Spacer(),
            _barButton(context, Icons.more_horiz, 'More options', onMore),
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
