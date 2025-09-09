import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gamepad_event_listener/gamepad_event_listener.dart';
import 'package:gamepads/gamepads.dart';

/// A widget which listens for game pad events, and passes them to [onEvent].
class GamepadListener extends StatefulWidget {
  /// Create an instance.
  const GamepadListener({
    required this.onEvent,
    required this.child,
    this.gamepadId,
    super.key,
  });

  /// The method to call when an event has been received.
  final void Function(GamepadListenerEvent event) onEvent;

  /// The widget below this widget in the tree.
  final Widget child;

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
    final GamepadListenerEvent event;
    switch (e.type) {
      case KeyType.analog:
        event = GamepadListenerAnalogEvent(
          gamepadId: e.gamepadId,
          name: e.key,
          value: e.value,
        );
      case KeyType.button:
        event = GamepadListenerButtonEvent(
          gamepadId: e.gamepadId,
          name: e.key,
          state: e.value == 1.0 ? ButtonState.pressed : ButtonState.released,
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
