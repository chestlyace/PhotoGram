import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/libraryScreen.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
      home: const LibraryScreen(),
    );
  }
}
