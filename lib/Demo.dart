/* important rules of dart: 
    - "R" : reload program with ease
    - click the link for flutter/dart dev tools
*/


//import necessary libraries
import 'package:flutter/material.dart';

// main function: return nothing, with no arguments
void main() {
  runApp(const MyApp());
}

// MyApp class
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // The ROOT of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // app title
      title: 'Satsuma Player',
      theme: ThemeData(
        // Theme of the application goes here
        colorScheme: .fromSeed(seedColor: Colors.deepOrange),
      ),
      // home page title
      home: const MyHomePage(title: 'Satsuma Player'),
    );
  }
}

// This widget is the home page of your application. It is stateful, meaning
// that it has a State object (defined below) that contains fields that affect
// how it looks.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// current homepage state?
class _MyHomePageState extends State<MyHomePage> {
  // initialize the counter variable
  int _counter = 0;

  // define the increment counter function
  void _incrementCounter() {
    // the setState func must be called so the build method is rerun
    // otherwise, nothing would update
    setState(() {
      _counter++;
    });
  }

  // override the build function
  // it returns a widget and takes a BuildContext object, context
  // This method is rerun every time setState is called, for instance as done
  // by the _incrementCounter method above.
  @override
  Widget build(BuildContext context) {
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.amber,
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // setting the title on the app bar
        title: Text(widget.title),
      ),
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      body: Center(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        child: Column(
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('Your songs go here: '),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
