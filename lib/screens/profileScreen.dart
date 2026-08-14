import 'package:flutter/material.dart';

import '../components/bottomNav.dart';
import '../components/neumorphic.dart';
import '../components/photoTile.dart';
import '../components/topBar.dart';
import '../theme.dart';
import 'albumsScreen.dart';
import 'personAlbumScreen.dart';
import 'searchScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _name = 'Sarah Miller';
  static const _handle = '@sarahm';
  static const _people = ['David', 'Emma', 'James', 'Sophie'];

  static const _settings = [
    (Icons.notifications_outlined, 'Notifications'),
    (Icons.lock_outline, 'Privacy & Sharing'),
    (Icons.backup_outlined, 'Backup preferences'),
    (Icons.data_usage, 'Storage & data'),
    (Icons.help_outline, 'Help & support'),
  ];

  void _placeholder(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SearchScreen()),
    );
  }

  void _openAlbums() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const AlbumsScreen()),
    );
  }

  void _openPerson(String name) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PersonAlbumScreen(personName: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(24, 92, 24, 150),
            children: [
              const _ProfileHeader(name: _name, handle: _handle),
              const SizedBox(height: AppSpacing.sectionGap),
              _StorageCard(
                onManage: () => _placeholder('Storage management is coming soon.'),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              const _SectionLabel('Connected Accounts'),
              const SizedBox(height: 16),
              const _AccountRow(icon: Icons.perm_media, label: 'Google Photos'),
              const SizedBox(height: 16),
              const _AccountRow(icon: Icons.cloud_sync, label: 'iCloud'),
              const SizedBox(height: AppSpacing.sectionGap),
              const _SectionLabel('People in your library'),
              const SizedBox(height: 16),
              _PeopleRow(names: _people, onTap: _openPerson),
              const SizedBox(height: AppSpacing.sectionGap),
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0x4DC6C6CB))),
                ),
                padding: const EdgeInsets.only(top: 16, bottom: 32),
                child: Column(
                  children: [
                    for (var i = 0; i < _settings.length; i++) ...[
                      if (i > 0) const SizedBox(height: 24),
                      _SettingsRow(
                        icon: _settings[i].$1,
                        label: _settings[i].$2,
                        onTap: () =>
                            _placeholder('${_settings[i].$2} is coming soon.'),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sectionGap),
              _SignOut(onTap: () => _placeholder('Signing out is coming soon.')),
            ],
          ),
          Positioned(
            top: 12,
            left: 24,
            right: 24,
            child: PhotogramTopBar(
              onCamera: () => _placeholder('Camera is coming soon.'),
              onSearch: _openSearch,
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
                    _openSearch();
                  case PhotogramTab.albums:
                    _openAlbums();
                  case PhotogramTab.profile:
                    break;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.name, required this.handle});

  final String name;
  final String handle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 128,
          height: 128,
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: AppColors.canvas,
            shape: BoxShape.circle,
            boxShadow: NeumorphicShadows.convex,
          ),
          child: ClipOval(child: PlaceholderArtwork(seed: 'sarah')),
        ),
        const SizedBox(height: 24),
        Text(name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          handle,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _StorageCard extends StatelessWidget {
  const _StorageCard({required this.onManage});

  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      radius: AppRadii.card,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Storage', style: Theme.of(context).textTheme.headlineMedium),
              const Spacer(),
              const Icon(Icons.cloud, size: 22, color: AppColors.onSurfaceVariant),
            ],
          ),
          const SizedBox(height: 16),
          const _StorageBar(fraction: 14.2 / 15),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '14.2 GB',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'of 15 GB used',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
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

class _StorageBar extends StatelessWidget {
  const _StorageBar({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      variant: NeumorphicVariant.concave,
      color: AppColors.surfaceContainerHighest,
      radius: 6,
      child: SizedBox(
        height: 12,
        child: FractionallySizedBox(
          widthFactor: fraction,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.outline,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
        ),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05,
            ),
      ),
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
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
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF34A853),
              boxShadow: NeumorphicShadows.convex,
            ),
            child: SizedBox(width: 12, height: 12),
          ),
        ],
      ),
    );
  }
}

class _PeopleRow extends StatelessWidget {
  const _PeopleRow({required this.names, required this.onTap});

  final List<String> names;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (var i = 0; i < names.length; i++) ...[
            if (i > 0) const SizedBox(width: 24),
            _PersonTile(name: names[i], onTap: () => onTap(names[i])),
          ],
        ],
      ),
    );
  }
}

class _PersonTile extends StatelessWidget {
  const _PersonTile({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: AppColors.canvas,
              shape: BoxShape.circle,
              boxShadow: NeumorphicShadows.convex,
            ),
            child: ClipOval(child: PlaceholderArtwork(seed: name)),
          ),
          const SizedBox(height: 8),
          Text(name, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: AppColors.outline),
        ],
      ),
    );
  }
}

class _SignOut extends StatelessWidget {
  const _SignOut({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Sign out',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.error, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}
