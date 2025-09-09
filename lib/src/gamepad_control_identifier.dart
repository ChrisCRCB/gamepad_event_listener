/// An identifier for a gamepad control.
class GamepadControlIdentifier {
  /// Create an instance.
  const GamepadControlIdentifier({required this.name, this.gamepadId});

  /// The name of this control.
  final String name;

  /// The ID of the gamepad which should be listened for.
  ///
  /// If [gamepadId] is `null`, then matching events from all gamepads will match.
  final String? gamepadId;

  /// Returns `true` if either [gamepadId] is `null`, or is the same as [id].
  bool matchesGamepadId(final String id) => [null, id].contains(gamepadId);
}

/// An identifier for a gamepad analog control.
class GamepadAnalogIdentifier extends GamepadControlIdentifier {
  /// Create an instance.
  const GamepadAnalogIdentifier({required super.name, super.gamepadId});
}

/// The identifier for a gamepad button.
class GamepadButtonIdentifier extends GamepadControlIdentifier {
  /// Create an instance.
  const GamepadButtonIdentifier({required super.name, super.gamepadId});
}
