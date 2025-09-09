import 'package:gamepads/gamepads.dart';

/// The type of an abstracted [GamepadEvent].
sealed class GamepadListenerEvent {
  /// Create an instance.
  const GamepadListenerEvent({required this.gamepadId, required this.name});

  /// The ID of the gamepad which emitted this event.
  final String gamepadId;

  /// The system name for this event.
  final String name;
}

/// An analog event.
class GamepadListenerAnalogEvent extends GamepadListenerEvent {
  /// Create an instance.
  const GamepadListenerAnalogEvent({
    required super.gamepadId,
    required super.name,
    required this.value,
  });

  /// The value of the analog control which generated the event.
  final double value;
}

/// The state of a button.
///
/// This enum is used by the [GamepadListenerButtonEvent] class.
enum ButtonState {
  /// The button has been pressed.
  pressed,

  /// The button has been released.
  released,
}

/// A button event.
class GamepadListenerButtonEvent extends GamepadListenerEvent {
  /// Create an instance.
  const GamepadListenerButtonEvent({
    required super.gamepadId,
    required super.name,
    required this.state,
  });

  /// Whether the button is pressed or not.
  final ButtonState state;
}
