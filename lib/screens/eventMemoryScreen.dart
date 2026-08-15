import 'package:flutter/material.dart';

import '../components/mosaicGrid.dart';
import '../components/neumorphic.dart';
import '../components/photoTile.dart';
import '../theme.dart';
import 'photoDetailScreen.dart';
import 'searchScreen.dart';

class EventMemoryScreen extends StatelessWidget {
  const EventMemoryScreen({super.key});

  static const _highlightSeeds = ['summer-beach', 'summer-sunset', 'summer-pier', 'summer-party'];

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

  void _openPhoto(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PhotoDetailScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spans = List.generate(
      _highlightSeeds.length,
      (_) => const TileSpan(1, 1),
    );

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(top: 92, bottom: 40),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
                child: _Cover(),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.containerMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summer Vacation 2025',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'July 15 - Aug 1',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.containerMargin),
                child: _SectionTitle('Highlights'),
              ),
              const SizedBox(height: 24),
              MosaicGrid(
                seeds: _highlightSeeds,
                spans: spans,
                onPhotoTap: (_) => _openPhoto(context),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.containerMargin),
                child: _ActionRow(
                  onShare: () => _comingSoon(context, 'Sharing is coming soon.'),
                  onLink: () => _comingSoon(context, 'Linking is coming soon.'),
                  onChat: () => _comingSoon(context, 'Chat is coming soon.'),
                  onMail: () => _comingSoon(context, 'Email is coming soon.'),
                  onApps: () => _comingSoon(context, 'Apps is coming soon.'),
                ),
              ),
            ],
          ),
          Positioned(
            top: 12,
            left: 24,
            right: 24,
            child: _EventTopBar(
              onBack: () => Navigator.of(context).pop(),
              onSearch: () => _openSearch(context),
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

class _Cover extends StatelessWidget {
  const _Cover();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: SizedBox(
        height: 280,
        width: double.infinity,
        child: PlaceholderArtwork(seed: 'summer'),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.onShare,
    required this.onLink,
    required this.onChat,
    required this.onMail,
    required this.onApps,
  });

  final VoidCallback onShare;
  final VoidCallback onLink;
  final VoidCallback onChat;
  final VoidCallback onMail;
  final VoidCallback onApps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ShareButton(onTap: onShare),
        const SizedBox(width: 8),
        _ActionIcon(
          icon: Icons.link,
          tooltip: 'Link',
          onTap: onLink,
        ),
        const SizedBox(width: 8),
        _ActionIcon(
          icon: Icons.chat_bubble_outline,
          tooltip: 'Chat',
          onTap: onChat,
        ),
        const SizedBox(width: 8),
        _ActionIcon(
          icon: Icons.mail_outline,
          tooltip: 'Email',
          onTap: onMail,
        ),
        const SizedBox(width: 8),
        _ActionIcon(
          icon: Icons.apps,
          tooltip: 'Apps',
          onTap: onApps,
        ),
      ],
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Share',
      child: GestureDetector(
        onTap: onTap,
        child: Neumorphic(
          radius: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.ios_share, size: 18, color: AppColors.onSurface),
              const SizedBox(width: 6),
              Text(
                'Share',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, required this.tooltip, required this.onTap});

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Neumorphic(
          radius: 32,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, size: 18, color: AppColors.onSurface),
          ),
        ),
      ),
    );
  }
}

class _EventTopBar extends StatelessWidget {
  const _EventTopBar({this.onBack, this.onSearch});

  final VoidCallback? onBack;
  final VoidCallback? onSearch;

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
            _barButton(context, Icons.search_rounded, 'Search', onSearch),
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
