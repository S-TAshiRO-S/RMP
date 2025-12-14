import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Map<String, dynamic>> loadConfig() async {
  final raw = await rootBundle.loadString('assets/app_config.json');
  return jsonDecode(raw) as Map<String, dynamic>;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cfg = await loadConfig();
  await Supabase.initialize(
    url: cfg['supabaseUrl'] as String,
    anonKey: cfg['supabaseAnonKey'] as String,
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class Message {
  final int id;
  final String content;
  final DateTime createdAt;

  Message({required this.id, required this.content, required this.createdAt});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id'] as int,
        content: (json['content'] ?? '') as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лаба 2',
      theme: ThemeData(useMaterial3: true),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<List<Message>> _future;
  final _controller = TextEditingController();
  String _draft = '';
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _future = _fetchMessages();
  }

  Future<List<Message>> _fetchMessages() async {
    final data = await supabase
        .from('messages')
        .select('id, content, created_at')
        .order('created_at', ascending: false);

    return (data as List)
        .cast<Map<String, dynamic>>()
        .map(Message.fromJson)
        .toList();
  }

  // Требование: кнопка обновить -> setState
  void _refresh() {
    setState(() {
      _future = _fetchMessages();
    });
  }

  // Требование: отправить -> insert в БД
  Future<void> _send() async {
    final text = _draft.trim();
    if (text.isEmpty) return;

    setState(() => _sending = true);
    try {
      await supabase.from('messages').insert({'content': text});
      _controller.clear();
      _draft = '';
      _refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка insert: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сообщения'),
        actions: [
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Обновить',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            // Требование: FutureBuilder
            child: FutureBuilder<List<Message>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Ошибка: ${snapshot.error}'));
                }

                final items = snapshot.data ?? const <Message>[];
                if (items.isEmpty) {
                  return const Center(child: Text('Пока нет сообщений'));
                }

                // Требование: List.generate
                return ListView(
                  padding: const EdgeInsets.all(12),
                  children: List.generate(items.length, (i) {
                    final m = items[i];
                    return Card(
                      child: ListTile(
                        title: Text(m.content),
                        subtitle: Text(m.createdAt.toLocal().toString()),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      // Требование: onChanged
                      onChanged: (v) => setState(() => _draft = v),
                      decoration: const InputDecoration(
                        hintText: 'Введите сообщение…',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _sending ? null : _send,
                    child: _sending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Отправить'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
