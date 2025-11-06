import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 1 — Basic Layout',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Здесь реализуем требуемый минимальный макет
    return Scaffold(
      appBar: AppBar(title: const Text('Лаб. №1 — Базовый макет')),
      body: Column(
        children: <Widget>[
          // Первый контейнер (width = ширина экрана, height = 150, цвет = синий)
          Container(
            width: double.infinity,
            height: 150,
            color: Colors.blueAccent,
            alignment: Alignment.center,
            child: const Text(
              'Первый контейнер',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),

          // Row с тремя Text, равномерно распределёнными по ширине
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text('Текст 1', style: TextStyle(fontSize: 16)),
                Text('Текст 2', style: TextStyle(fontSize: 16)),
                Text('Текст 3', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),

          // Второй контейнер (ширина = ширина экрана, height = 100, цвет = зелёный)
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
