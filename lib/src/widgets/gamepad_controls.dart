import 'package:flutter/material.dart';
import 'package:gamepad_event_listener/gamepad_event_listener.dart';

/// A widget which lets you use [Map]s for controlling analog controls and buttons.
class GamepadControls extends StatelessWidget {
  /// Create an instance.
  const GamepadControls({
    required this.child,
    this.analogHandlers = const {},
    this.buttonHandlers = const {},
    super.key,
  });

  /// The map of functions which should be fired when analog controls are used.
  final Map<
    GamepadAnalogIdentifier,
    void Function(String gamepadId, double value)
  >
  analogHandlers;

  /// The map of functions which should be fired when buttons are pressed or released.
  final Map<
    GamepadButtonIdentifier,
    void Function(String gamepadId, ButtonState state)
  >
  buttonHandlers;

  /// The child below this widget in the tree.
  final Widget child;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    return GamepadListener(
      onAnalog: (event) {
        for (final MapEntry(key: identifier, value: callback)
            in analogHandlers.entries) {
          if (identifier.matchesGamepadId(event.gamepadId) &&
              identifier.name == event.name) {
            callback(event.gamepadId, event.value);
          }
        }
      },
      onButton: (event) {
        for (final MapEntry(key: identifier, value: callback)
            in buttonHandlers.entries) {
          if (identifier.matchesGamepadId(event.gamepadId) &&
              identifier.name == event.name) {
            callback(event.gamepadId, event.state);
          }
        }
      },
      child: child,
    );
  }
}
