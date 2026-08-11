// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../theme.dart';
import 'placeholderAvatar.dart';

class TabAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TabAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.background.withValues(alpha: 0.85),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
            icon: const Icon(Icons.settings),
            color: AppColors.primary,
            tooltip: 'Settings',
          ),
          const Expanded(
            child: Text(
              'Photogram',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          ),
          const PlaceholderAvatar(seed: 'account-avatar'),
        ],
      ),
    );
  }
}
