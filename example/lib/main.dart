import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
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

enum _Mode {
  /// Print events.
  print,

  /// Pretend game.
  pretend,

  /// Options.
  options,
}

/// State for [HomePage].
class HomePageState extends State<HomePage> {
  /// The event to show.`
  GamepadListenerEvent? _event;

  /// The mode to use.
  late _Mode _mode;

  /// The button used for switching modes.
  late String modeButton;

  /// The button to use for firing.
  late String fireButton;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _mode = _Mode.print;
    modeButton = 'button-0';
    fireButton = 'button-3';
  }

  /// Build a widget.
  @override
  Widget build(BuildContext context) {
    switch (_mode) {
      case _Mode.print:
        final String description;
        final event = _event;
        switch (event) {
          case null:
            description = 'Press something on your gamepad.';
          case GamepadListenerAnalogEvent():
            description = '${event.name} = ${event.value}';
          case GamepadListenerButtonEvent():
            description = '${event.name} ${event.state.name}';
        }
        return GamepadListener(
          onEvent: (event) {
            if (event is GamepadListenerButtonEvent &&
                event.name == modeButton &&
                event.state == ButtonState.released) {
              setState(() => _mode = _Mode.pretend);
            } else {
              setState(() => _event = event);
            }
          },
          child: Scaffold(
            appBar: AppBar(title: Text('Gamepad Event Listener')),
            body: Focus(
              autofocus: true,
              child: Center(child: Text(description)),
            ),
          ),
        );
      case _Mode.pretend:
        return GamepadControls(
          analogHandlers: {
            GamepadAnalogIdentifier(name: 'pov'): (_, value) {
              if (value == 65535) {
                announce('Stop moving.');
              } else if (value == 0) {
                announce('Move forwards.');
              } else if (value == 9000) {
                announce('Move right.');
              } else if (value == 18000) {
                announce('Move backwards.');
              } else if (value == 27000) {
                announce('Move left.');
              } else {
                announce('Value is $value.');
              }
            },
          },
          buttonHandlers: {
            GamepadButtonIdentifier(name: modeButton): (_, state) {
              if (state == ButtonState.released) {
                setState(() => _mode = _Mode.options);
              }
            },
            GamepadButtonIdentifier(name: fireButton): (_, state) {
              switch (state) {
                case ButtonState.pressed:
                  announce('Fire weapon.');
                case ButtonState.released:
                  announce('Stop firing.');
              }
            },
          },
          child: Focus(autofocus: true, child: Text('Pretend game')),
        );
      case _Mode.options:
        return Scaffold(
          appBar: AppBar(title: Text('Options')),
          body: ListView(
            shrinkWrap: true,
            children: [
              GamepadListTile(
                autofocus: true,
                title: Text('Mode button'),
                subtitle: Text(modeButton),
                onButton: (event) {
                  if (event.name == fireButton) {
                    announce("$fireButton is already being used for firing.");
                  } else {
                    setState(() => modeButton = event.name);
                  }
                },
              ),
              GamepadListTile(
                title: Text('Fire button'),
                subtitle: Text(fireButton),
                onButton: (event) {
                  if (event.name == modeButton) {
                    announce(
                      'That button is already used for switching modes.',
                    );
                  } else {
                    setState(() => fireButton = event.name);
                  }
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => setState(() => _mode = _Mode.print),
            tooltip: 'Save options',
            child: Icon(Icons.save),
          ),
        );
    }
  }

  /// Make an announcement.
  Future<void> announce(final String message) =>
      SemanticsService.announce(message, TextDirection.ltr);
}
