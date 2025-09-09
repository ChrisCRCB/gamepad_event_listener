import 'package:flutter/material.dart';
import 'package:gamepad_event_listener/gamepad_event_listener.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gamepad Event Listener Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

/// The home page for the application.
class HomePage extends StatefulWidget {
  /// Create an instance.
  const HomePage({super.key});

  /// Create state for this widget.
  @override
  HomePageState createState() => HomePageState();
}

/// State for [HomePage].
class HomePageState extends State<HomePage> {
  /// The event to show.`
  GamepadEventListenerEvent? _event;

  /// Build a widget.
  @override
  Widget build(BuildContext context) {
    final String description;
    final event = _event;
    switch (event) {
      case null:
        description = 'Press something on your gamepad.';
      case GamepadEventListenerAnalogEvent():
        description = '${event.name} = ${event.value}';
      case GamepadEventListenerButtonEvent():
        description = '${event.name} ${event.pressed ? "pressed" : "released"}';
    }
    return GamepadEventListener(
      onEvent: (event) => setState(() => _event = event),
      child: Scaffold(
        appBar: AppBar(title: Text('Gamepad Event Listener')),
        body: Focus(autofocus: true, child: Center(child: Text(description))),
      ),
    );
  }
}
