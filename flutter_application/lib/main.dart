import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 1 — Interactive',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _onFabPressed() {
    // Сообщение увидишь в терминале, где запущен flutter run
    // ignore: avoid_print
    print('Button pressed!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Лаб. №1 — Интерфейс (Продвинутая)')),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        tooltip: 'Press',
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          // Первый контейнер
          Container(
            width: double.infinity,
            height: 140,
            color: Colors.blueAccent,
            alignment: Alignment.center,
            child: const Text(
              'Первый контейнер',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),

          // Row с тремя Text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('Текст 1', style: TextStyle(fontSize: 16)),
                Text('Текст 2', style: TextStyle(fontSize: 16)),
                Text('Текст 3', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),

          // Expanded с Row и двумя CircleAvatar
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Первый CircleAvatar (без изображения), radius 40
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.deepPurple,
                  child: Text('A', style: TextStyle(color: Colors.white, fontSize: 20)),
                ),

                // Второй CircleAvatar с backgroundImage (NetworkImage), radius 60
                CircleAvatar(
                  radius: 60,
                  backgroundImage: const NetworkImage('https://yt3.googleusercontent.com/Zw-TIkvjsdjeCzm6hT4GPDk-aAdx5WQnSStV33zbXcFX2Q1xv68clx9PLwk6KeloOZhhGIrgww=s900-c-k-c0x00ffffff-no-rj'),
                  backgroundColor: Colors.grey[200],
                ),
              ],
            ),
          ),

          // Второй контейнер
          Container(
            width: double.infinity,
            height: 100,
            color: Colors.greenAccent,
            alignment: Alignment.center,
            child: const Text(
              'Второй контейнер',
              style: TextStyle(color: Colors.black87, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}