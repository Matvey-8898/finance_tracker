import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/account/presentation/account_screen.dart';
import 'package:flutter_application_1/features/auth/presentation/auth_screen.dart';
import 'package:flutter_application_1/features/chat/presentation/chat_screen.dart';
import 'package:flutter_application_1/features/feed/presentation/feed_screen.dart';
import 'package:flutter_application_1/features/home/presentation/home_screen.dart';
import 'package:flutter_application_1/features/register/presentation/register_screen.dart';
import 'package:flutter_application_1/features/services/presentation/services_screen.dart';
import 'package:flutter_application_1/shared/etc/navigation_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MainApp(prefs: prefs));
}

class MainApp extends StatefulWidget {
  final SharedPreferences prefs;

  const MainApp({super.key, required this.prefs});

  @override
  State<MainApp> createState() => MainAppState();

  static MainAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainAppState>();
  }
}

class MainAppState extends State<MainApp> {
  ThemeMode themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  void loadTheme() {
    final theme = widget.prefs.getString('theme') ?? 'system';
    print(widget.prefs.getString('recipes'));
    setState(() {
      themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == 'ThemeMode.$theme',
        orElse: () => ThemeMode.system,
      );
    });
  }

  void changeTheme(ThemeMode mode) {
    setState(() {
      themeMode = mode;
    });
    widget.prefs.setString('theme', mode.toString().split('.').last);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Курс Flutter Проект Тест',
      initialRoute: "/",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      routes: {
        "/": (context) => const NavigationWrapper(),
        "/home": (context) => FinanceSummaryScreen(),
        "/feed": (context) => FinanceVisualizerApp(),
        "/chat": (context) => const ChatScreen(),
        "/auth": (context) => const AuthScreen(),
        "/register": (context) => const RegisterScreen(),
        "/services": (context) => FinanceTracker(),
        "/account": (context) => const AccountScreen(),
      },
    );
  }
}
