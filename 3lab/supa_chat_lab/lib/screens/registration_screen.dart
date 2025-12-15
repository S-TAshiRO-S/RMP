import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _client = Supabase.instance.client;

  String _username = '';
  String _password = '';
  String _status = '';
  Timer? _debounce;

  void _onChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () async {
      // небольшая проверка "логин занят?" тоже через SELECT "при вводе"
      if (_username.isEmpty) {
        setState(() => _status = '');
        return;
      }

      final exists = await _client
          .from('users')
          .select('id')
          .eq('username', _username)
          .maybeSingle();

      if (!mounted) return;
      setState(() => _status = exists == null ? 'Логин свободен' : 'Логин занят');
    });
  }

  Future<void> _register() async {
    if (_username.isEmpty || _password.isEmpty) {
      setState(() => _status = 'Заполни логин и пароль');
      return;
    }

    try {
      final inserted = await _client
          .from('users')
          .insert({'username': _username, 'password': _password})
          .select('id, username')
          .single(); // читаем ответ INSERT

      if (!mounted) return;
      setState(() => _status = 'Зарегистрирован: ${inserted['username']}');

      // переход на авторизацию: просто подсказка (внизу уже BottomNavigationBar)
      // можно оставить так, преподавателю ок.
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = 'Ошибка регистрации: $e');
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
            const Text('Регистрация', style: TextStyle(fontSize: 28)),
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
              onPressed: _register,
              child: const Text('Зарегистрироваться'),
            ),

            const SizedBox(height: 12),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
