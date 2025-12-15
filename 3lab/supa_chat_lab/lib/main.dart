import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_config.dart';
import 'screens/main_screen.dart';
import 'screens/messages_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cfg = await AppConfig.load();
  await Supabase.initialize(
    url: cfg.supabaseUrl,
    anonKey: cfg.supabaseAnonKey,
  );

  final prefs = await SharedPreferences.getInstance();
  final savedUsername = prefs.getString('username');

  runApp(MyApp(savedUsername: savedUsername));
}

class MyApp extends StatelessWidget {
  final String? savedUsername;
  const MyApp({super.key, required this.savedUsername});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лаба 3',
      debugShowCheckedModeBanner: false,
      home: savedUsername == null
          ? const MainScreen()
          : MessagesScreen(username: savedUsername!),
    );
  }
}
