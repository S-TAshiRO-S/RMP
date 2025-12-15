import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'messages_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _client = Supabase.instance.client;

  String _username = '';
  String _password = '';
  String _status = '';
  Timer? _debounce;
  bool _checking = false;

  void _onChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () async {
      // чтобы SELECT действительно был "при вводе", но без спама запросов
      if (_username.isEmpty || _password.isEmpty) {
        setState(() => _status = '');
        return;
      }
      await _tryLogin(auto: true);
    });
  }

  Future<void> _tryLogin({required bool auto}) async {
    if (_checking) return;
    setState(() {
      _checking = true;
      _status = auto ? 'Проверка...' : 'Вход...';
    });

    try {
      final res = await _client
          .from('users')
          .select('username')
          .eq('username', _username)
          .eq('password', _password)
          .maybeSingle();

      if (!mounted) return;

      if (res == null) {
        setState(() => _status = 'Пользователь не найден');
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', _username);

        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => MessagesScreen(username: _username),
          ),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _status = 'Ошибка: $e');
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Авторизация', style: TextStyle(fontSize: 28)),
            const SizedBox(height: 16),

            TextFormField(
              decoration: const InputDecoration(labelText: 'Логин'),
              onChanged: (v) {
                _username = v.trim();
                _onChanged();
              },
            ),
            const SizedBox(height: 12),

            TextFormField(
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
              onChanged: (v) {
                _password = v;
                _onChanged();
              },
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _checking ? null : () => _tryLogin(auto: false),
              child: const Text('Войти'),
            ),

            const SizedBox(height: 12),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
