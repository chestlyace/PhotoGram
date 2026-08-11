// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../components/placeholderAvatar.dart';
import '../theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          color: AppColors.background.withValues(alpha: 0.85),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.primary),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed('/settings'),
                icon: const Icon(Icons.settings),
                color: AppColors.secondary,
                tooltip: 'Settings',
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _profileHeader(),
          const SizedBox(height: 24),
          _storageCard(context),
          const SizedBox(height: 24),
          const Text(
            'Connected Accounts',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          _accountsCard(),
          const SizedBox(height: 24),
          _peopleSection(),
          const SizedBox(height: 24),
          _settingsList(),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text('Sign Out', style: TextStyle(fontSize: 14, color: AppColors.secondary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            const PlaceholderAvatar(seed: 'sarah', size: 96),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Sarah Jenkins',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
        ),
        const SizedBox(height: 2),
        const Text('@sjenkins', style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _storageCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.cloud_done, size: 20, color: AppColors.success),
              SizedBox(width: 8),
              Text(
                'Photogram Storage',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 6,
              color: AppColors.surfaceContainer,
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 2 / 3,
                child: Container(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '12.4 GB backed up · 3,204 items',
            style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/settings'),
              style: TextButton.styleFrom(
                backgroundColor: AppColors.surfaceContainerLow,
                foregroundColor: AppColors.primary,
              ),
              child: const Text('Manage storage'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountsCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          _accountRow(icon: Icons.send, iconBg: const Color(0xFFE3F2FD), iconColor: const Color(0xFF1E88E5), name: 'Telegram', connected: true),
          Divider(height: 1, color: AppColors.surfaceContainer),
          _accountRow(icon: Icons.calendar_today, iconBg: const Color(0xFFE8F5E9), iconColor: const Color(0xFF43A047), name: 'Google Calendar', connected: true),
          Divider(height: 1, color: AppColors.surfaceContainer),
          _accountRow(icon: Icons.photo, iconBg: AppColors.surfaceContainer, iconColor: AppColors.onSurfaceVariant, name: 'Google Photos', connected: false),
        ],
      ),
    );
  }

  Widget _accountRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String name,
    required bool connected,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 16, color: AppColors.primary)),
                const SizedBox(height: 2),
                if (connected)
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                      ),
                      const Text('Connected', style: TextStyle(fontSize: 12, color: AppColors.success)),
                    ],
                  )
                else
                  const Text('Not connected', style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          if (!connected)
            TextButton(
              onPressed: () {},
              child: const Text('Connect'),
            ),
        ],
      ),
    );
  }

  Widget _peopleSection() {
    const names = ['Emma', 'David', 'Sarah', 'Mom'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'People',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text('Manage', style: TextStyle(fontSize: 14, color: AppColors.secondary)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < names.length; i++) ...[
                Column(
                  children: [
                    PlaceholderAvatar(seed: names[i].toLowerCase(), size: 64),
                    const SizedBox(height: 6),
                    Text(names[i], style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                  ],
                ),
                if (i < names.length - 1) const SizedBox(width: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _settingsList() {
    final rows = <(IconData, String, String?)>[
      (Icons.notifications, 'Notifications', null),
      (Icons.shield, 'Privacy & Sharing', null),
      (Icons.backup, 'Backup', 'Wi-Fi only'),
      (Icons.storage, 'Storage & data', null),
      (Icons.help, 'Help & support', null),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            _settingsRow(icon: rows[i].$1, label: rows[i].$2, detail: rows[i].$3),
            if (i < rows.length - 1) Divider(height: 1, color: AppColors.surfaceContainer),
          ],
        ],
      ),
    );
  }

  Widget _settingsRow({required IconData icon, required String label, String? detail}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.secondary),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 16, color: AppColors.primary)),
          ),
          if (detail != null)
            Text(detail, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
          if (detail == 'Wi-Fi only') ...[
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 24,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Align(
                alignment: Alignment.centerRight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: SizedBox(width: 20, height: 20),
                ),
              ),
            ),
          ] else ...[
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.onSurfaceVariant),
          ],
        ],
      ),
    );
  }
}
