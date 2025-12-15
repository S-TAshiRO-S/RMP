import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  final String supabaseUrl;
  final String supabaseAnonKey;

  AppConfig({required this.supabaseUrl, required this.supabaseAnonKey});

  static Future<AppConfig> load() async {
    final raw = await rootBundle.loadString('assets/app_config.json');
    final jsonMap = jsonDecode(raw) as Map<String, dynamic>;
    return AppConfig(
      supabaseUrl: jsonMap['supabaseUrl'] as String,
      supabaseAnonKey: jsonMap['supabaseAnonKey'] as String,
    );
  }
}
