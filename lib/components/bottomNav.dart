import 'package:flutter/material.dart';

import '../theme.dart';
import 'neumorphic.dart';

enum PhotogramTab { library, search, albums, profile }

class PhotogramNav extends StatelessWidget {
  const PhotogramNav({
    super.key,
    required this.selected,
    this.onSelect,
  });

  final PhotogramTab selected;
  final ValueChanged<PhotogramTab>? onSelect;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      radius: AppRadii.navPill,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(
              icon: Icons.photo_library_rounded,
              tooltip: 'Library',
              tab: PhotogramTab.library,
              selected: selected,
              onTap: onSelect,
            ),
            _NavItem(
              icon: Icons.search_rounded,
              tooltip: 'Search',
              tab: PhotogramTab.search,
              selected: selected,
              onTap: onSelect,
            ),
            _NavItem(
              icon: Icons.auto_stories_outlined,
              tooltip: 'Albums',
              tab: PhotogramTab.albums,
              selected: selected,
              onTap: onSelect,
            ),
            _NavItem(
              icon: Icons.person_outline_rounded,
              tooltip: 'Profile',
              tab: PhotogramTab.profile,
              selected: selected,
              onTap: onSelect,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.tooltip,
    required this.tab,
    required this.selected,
    this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final PhotogramTab tab;
  final PhotogramTab selected;
  final ValueChanged<PhotogramTab>? onTap;

  @override
  Widget build(BuildContext context) {
    final active = tab == selected;
    final color = active
        ? AppColors.onSurface
        : AppColors.onSurfaceVariant.withValues(alpha: 0.6);
    final Widget content = SizedBox(
      width: 40,
      height: 40,
      child: Icon(icon, size: 18, color: color),
    );
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap == null ? null : () => onTap!(tab),
        child: active
            ? Neumorphic(
                variant: NeumorphicVariant.concave,
                radius: AppRadii.navItem,
                child: content,
              )
            : content,
      ),
    );
  }
}
