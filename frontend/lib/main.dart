import 'package:antipattern/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:antipattern/theme/app_theme.dart';

// ---------------------------------------------
// GLOBAL Theme Controller
// ---------------------------------------------
class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;

  void setTheme(bool isDark) {
    _mode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

final themeController = ThemeController();

// ---------------------------------------------
// MAIN APP
// ---------------------------------------------
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp.router(
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
          themeMode: themeController.mode,

          // Light / Dark Theme via centralized builders
          theme: buildLightTheme(),
          darkTheme: buildDarkTheme(),
        );
      },
    );
  }
}
