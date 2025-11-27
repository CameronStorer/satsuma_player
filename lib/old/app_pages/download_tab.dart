// 1. Import the Flutter material library
import 'package:flutter/material.dart';

// 2. Define the StatefulWidget class
class HomeTabScreen extends StatefulWidget {
  // A constructor is optional, but good practice.
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

// 3. Define the State class
class _HomeTabScreenState extends State<HomeTabScreen> {
  // You can manage state here, e.g., fetched data, counters, etc.
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // 4. Build the UI for this tab content
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Welcome to the Home Tab!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Button taps: $_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _incrementCounter,
            child: const Text('Tap Me'),
          ),
        ],
      ),
    );
  }
}