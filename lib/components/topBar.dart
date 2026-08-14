import 'package:flutter/material.dart';

import '../theme.dart';
import 'neumorphic.dart';

class PhotogramTopBar extends StatelessWidget {
  const PhotogramTopBar({
    super.key,
    this.title = 'Photogram',
    this.onCamera,
    this.onSearch,
  });

  final String title;
  final VoidCallback? onCamera;
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
            _TopBarButton(
              icon: Icons.photo_camera_outlined,
              tooltip: 'Camera',
              onTap: onCamera,
            ),
            const Spacer(),
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const Spacer(),
            _TopBarButton(
              icon: Icons.search_rounded,
              tooltip: 'Search',
              onTap: onSearch,
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}

class _TopBarButton extends StatelessWidget {
  const _TopBarButton({
    required this.icon,
    required this.tooltip,
    this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Neumorphic(
          radius: AppRadii.headerButton,
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(icon, size: 16, color: AppColors.onSurface),
          ),
        ),
      ),
    );
  }
}

class PhotogramSearchBar extends StatelessWidget {
  const PhotogramSearchBar({super.key, this.controller, this.onChanged});

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Neumorphic(
      radius: AppRadii.headerPill,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              Icons.search_rounded,
              size: 18,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                style: textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Search photos',
                  hintStyle: textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
