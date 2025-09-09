import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamepad_event_listener/gamepad_event_listener.dart';
import 'package:gamepads/gamepads.dart';

/// A widget which listens for game pad events, and passes them to [onEvent].
class GamepadListener extends StatefulWidget {
  /// Create an instance.
  const GamepadListener({
    required this.child,
    this.onAnalog,
    this.onButton,
    this.gamepadId,
    super.key,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The function to call when an analog control is used on this [ListTile].
  final void Function(GamepadListenerAnalogEvent event)? onAnalog;

  /// The function to call when a button is pressed on this [ListTile].
  final void Function(GamepadListenerButtonEvent event)? onButton;

  /// The ID of the gamepad whose events should be streamed.
  ///
  /// If [gamepadId] is `null`, then events from all gamepads will be streamed.
  final String? gamepadId;

  /// Create state for this widget.
  @override
  GamepadListenerState createState() => GamepadListenerState();
}

/// State for [GamepadListener].
class GamepadListenerState extends State<GamepadListener> {
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
    switch (e.type) {
      case KeyType.analog:
        widget.onAnalog?.call(
          GamepadListenerAnalogEvent(
            gamepadId: e.gamepadId,
            name: e.key,
            value: e.value,
          ),
        );
      case KeyType.button:
        widget.onButton?.call(
          GamepadListenerButtonEvent(
            gamepadId: e.gamepadId,
            name: e.key,
            state: e.value == 1.0 ? ButtonState.pressed : ButtonState.released,
          ),
        );
    }
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
