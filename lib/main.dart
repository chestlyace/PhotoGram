import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/onboardingScreen.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const PhotogramApp());
}

class PhotogramApp extends StatefulWidget {
  const PhotogramApp({super.key});

  @override
  State<PhotogramApp> createState() => _PhotogramAppState();
}

class _PhotogramAppState extends State<PhotogramApp>
    with WidgetsBindingObserver {
  Brightness _brightness = Brightness.light;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _applyBrightness(
        WidgetsBinding.instance.platformDispatcher.platformBrightness);
  }

  @override
  void didChangePlatformBrightness() {
    _applyBrightness(
        WidgetsBinding.instance.platformDispatcher.platformBrightness);
  }

  void _applyBrightness(Brightness brightness) {
    AppColors.setDark(brightness == Brightness.dark);
    if (brightness != _brightness) {
      setState(() => _brightness = brightness);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photogram',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: _brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const OnboardingScreen(),
    );
  }
}
