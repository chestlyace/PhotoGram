// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../components/onboardingShell.dart';
import '../components/placeholderArtwork.dart';
import '../theme.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Photogram',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: const SizedBox(
                        width: 192,
                        height: 192,
                        child: PlaceholderArtwork(
                          seed: 'signin-hero',
                          icon: Icons.camera_alt_outlined,
                          iconSize: 64,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Ready to begin?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.02,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Sign in with your Telegram account to sync your library across all your devices seamlessly.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/library', (route) => false),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size.fromHeight(56),
                        shape: const StadiumBorder(),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.send),
                          SizedBox(width: 8),
                          Text('Sign in with Telegram'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Learn more about storage'),
                          Icon(Icons.chevron_right, size: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const OnboardingDots(activeIndex: 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
