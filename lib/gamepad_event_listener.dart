import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamepads/gamepads.dart';

/// The type of an abstracted [GamepadEvent].
sealed class GamepadEventListenerEvent {
  /// Create an instance.
  const GamepadEventListenerEvent({
    required this.gamepadId,
    required this.name,
  });

  /// The ID of the gamepad which emitted this event.
  final String gamepadId;

  /// The system name for this event.
  final String name;
}

/// An analog event.
class GamepadEventListenerAnalogEvent extends GamepadEventListenerEvent {
  /// Create an instance.
  const GamepadEventListenerAnalogEvent({
    required super.gamepadId,
    required super.name,
    required this.value,
  });

  /// The value of the analog control which generated the event.
  final double value;
}

/// A button event.
class GamepadEventListenerButtonEvent extends GamepadEventListenerEvent {
  /// Create an instance.
  const GamepadEventListenerButtonEvent({
    required super.gamepadId,
    required super.name,
    required this.pressed,
  });

  /// Whether the button is pressed or not.
  final bool pressed;
}

/// A widget which listens for game pad events, and passes them to [onEvent].
class GamepadEventListener extends StatefulWidget {
  /// Create an instance.
  const GamepadEventListener({
    required this.onEvent,
    required this.child,
    this.gamepadId,
    super.key,
  });

  /// The method to call when an event has been received.
  final void Function(GamepadEventListenerEvent event) onEvent;

  /// The widget below this widget in the tree.
  final Widget child;

  /// The ID of the gamepad whose events should be streamed.
  ///
  /// If [gamepadId] is `null`, then events from all gamepads will be streamed.
  final String? gamepadId;

  /// Create state for this widget.
  @override
  GamepadEventListenerState createState() => GamepadEventListenerState();
}

/// State for [GamepadEventListener].
class GamepadEventListenerState extends State<GamepadEventListener> {
  /// The stream subscription to use.
  late final StreamSubscription<GamepadEvent> _subscription;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    final id = widget.gamepadId;
    if (id == null) {
      _subscription = Gamepads.events.listen(_handleEvent);
    } else {
      _subscription = Gamepads.eventsByGamepad(id).listen(_handleEvent);
    }
  }

  void _handleEvent(final GamepadEvent e) {
    final GamepadEventListenerEvent event;
    switch (e.type) {
      case KeyType.analog:
        event = GamepadEventListenerAnalogEvent(
          gamepadId: e.gamepadId,
          name: e.key,
          value: e.value,
        );
      case KeyType.button:
        event = GamepadEventListenerButtonEvent(
          gamepadId: e.gamepadId,
          name: e.key,
          pressed: e.value == 1.0,
        );
    }
    widget.onEvent(event);
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => widget.child;
}
