import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carpool/pages/splash_screen.dart';
import 'package:carpool/authentication/login_screen.dart';
import 'package:carpool/authentication/signup_screen.dart';
import 'package:carpool/pages/home_screen.dart';
import 'package:carpool/pages/my_profile_screen.dart';
import 'package:carpool/pages/my_schedule_screen.dart';
import 'package:carpool/pages/create_group_screen.dart';
import 'package:carpool/pages/search_group_screen.dart';
import 'package:carpool/pages/my_groups_screen.dart';
import 'package:carpool/pages/settings_screen.dart';
import 'package:carpool/pages/map_integration_page.dart';
import 'package:carpool/pages/search_bar_with_filters_page.dart'; // Add this import
import 'package:carpool/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locale = Locale(prefs.getString('language') ?? 'he');
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carpool Management',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.black,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
        ),
      ),
      locale: _locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) {
          return supportedLocales.first;
        }
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(onLocaleChange: setLocale),
        '/login': (context) => LoginScreen(onLocaleChange: setLocale),
        '/signup': (context) => SignUpScreen(onLocaleChange: setLocale),
        '/home': (context) => HomeScreen(onLocaleChange: setLocale),
        '/profile': (context) => MyProfileScreen(onLocaleChange: setLocale),
        '/schedule': (context) => MyScheduleScreen(onLocaleChange: setLocale),
        '/createGroup': (context) => CreateGroupScreen(onLocaleChange: setLocale),
        '/searchGroup': (context) => SearchGroupScreen(onLocaleChange: setLocale),
        '/myGroups': (context) => MyGroupsScreen(onLocaleChange: setLocale),
        '/settings': (context) => SettingsScreen(onLocaleChange: setLocale),
        '/map': (context) => MapIntegrationPage(onLocaleChange: setLocale),
        '/searchWithFilters': (context) => SearchBarWithFiltersPage(onLocaleChange: setLocale), // Add this line
      },
    );
  }
}
