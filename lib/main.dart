import 'package:flutter/material.dart';
import 'components/bottomNavShell.dart';
import 'screens/eventScreen.dart';
import 'screens/personScreen.dart';
import 'screens/photoDetailScreen.dart';
import 'screens/settingsScreen.dart';
import 'screens/signInScreen.dart';
import 'screens/valuePropScreen.dart';
import 'screens/welcomeScreen.dart';
import 'theme.dart';

void main() {
  runApp(const PhotogramApp());
}

class PhotogramApp extends StatelessWidget {
  const PhotogramApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photogram',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (_) => const WelcomeScreen(),
        '/value-prop': (_) => const ValuePropScreen(),
        '/sign-in': (_) => const SignInScreen(),
        '/library': (_) => const BottomNavShell(initialIndex: 0),
        '/search': (_) => const BottomNavShell(initialIndex: 1),
        '/albums': (_) => const BottomNavShell(initialIndex: 2),
        '/profile': (_) => const BottomNavShell(initialIndex: 3),
        '/event': (_) => const EventScreen(),
        '/person': (_) => const PersonScreen(),
        '/photo': (_) => const PhotoDetailScreen(),
        '/settings': (_) => const SettingsScreen(),
      },
    );
  }
}
