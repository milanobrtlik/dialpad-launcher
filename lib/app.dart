import 'package:dialpad_launcher/launcher/view/launcher_page.dart';
import 'package:dialpad_launcher/settings/about/view/about_page.dart';
import 'package:dialpad_launcher/settings/excluded/view/excluded_page.dart';
import 'package:dialpad_launcher/settings/favorites/view/favorites_page.dart';
import 'package:dialpad_launcher/settings/home/view/settings_page.dart';
import 'package:dialpad_launcher/settings/prison/view/prison_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    return MaterialApp(
      routes: {
        Routes.home.route: (ctx) => const LauncherPage(),
        Routes.settings.route: (ctx) => const SettingsPage(),
        Routes.prison.route: (ctx) => const PrisonPage(),
        Routes.excluded.route: (ctx) => const ExcludedPage(),
        Routes.favorites.route: (ctx) => const FavoritesPage(),
        Routes.about.route: (ctx) => const AboutPage(),
      },
      initialRoute: '/',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
        ),
        useMaterial3: true,
      ),
    );
  }
}

enum Routes {
  home,
  settings,
  prison,
  excluded,
  favorites,
  about,
}

extension RoutesExension on Routes {
  static const list = {
    Routes.home: '/',
    Routes.settings: '/settings',
    Routes.prison: '/settings/prison',
    Routes.excluded: '/settings/excluded',
    Routes.favorites: '/settings/favorites',
    Routes.about: '/settings/about',
  };

  String get route => list[this]!;
}
