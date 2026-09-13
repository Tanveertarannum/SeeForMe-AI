import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const SeeForMeApp());
}

class SeeForMeApp extends StatelessWidget {
  const SeeForMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SeeForMe AI',
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}