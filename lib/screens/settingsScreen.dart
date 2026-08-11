// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../components/backAppBar.dart';
import '../theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(title: 'Upload & Storage'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Storage Options',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            const Text(
              'Choose how you want to store your memories.',
              style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            _storageCard(),
            const SizedBox(height: 16),
            _telegramCard(),
          ],
        ),
      ),
    );
  }

  Widget _storageCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                child: const Icon(Icons.cloud_done, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Use Photogram Storage',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Recommended',
                        style: TextStyle(fontSize: 12, color: AppColors.onSecondaryContainer),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Fast, secure, and ready to use. Optimized for your media library.',
                      style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _toggle(on: true),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Active',
              style: TextStyle(fontSize: 14, color: AppColors.primary.withValues(alpha: 0.8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _telegramCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: AppColors.surfaceContainerHigh, shape: BoxShape.circle),
                child: const Icon(Icons.forum, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connect my own Telegram',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: AppColors.primary),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Use your own Telegram group or channel for unlimited private storage.',
                      style: TextStyle(fontSize: 16, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _toggle(on: false),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Connect'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggle({required bool on}) {
    return Container(
      width: 44,
      height: 24,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: on ? AppColors.primary : AppColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Align(
        alignment: on ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: on ? Colors.white : AppColors.outline, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
