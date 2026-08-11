// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../components/placeholderArtwork.dart';
import '../theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const PlaceholderArtwork(
            seed: 'welcome-hero',
            icon: Icons.landscape,
            iconSize: 96,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.background.withValues(alpha: 0.4),
                  AppColors.background,
                ],
                stops: const [0, 0.5, 1],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Your memories,\nbeautifully archived.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      height: 56 / 48,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.02,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Private, secure, and seamlessly powered by your Telegram storage.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      height: 28 / 18,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 48),
                  FilledButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/value-prop'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: const StadiumBorder(),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Get Started'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
