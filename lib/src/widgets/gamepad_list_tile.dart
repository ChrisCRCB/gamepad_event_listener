import 'package:flutter/material.dart';
import 'package:gamepad_event_listener/gamepad_event_listener.dart';

/// The default `onTap`.
void defaultOnTap() {}

/// A [ListTile] which responds to [GamepadListenerEvent]s when it is focused.
class GamepadListTile extends StatefulWidget {
  /// Create an instance.
  const GamepadListTile({
    this.title,
    this.subtitle,
    this.autofocus = false,
    this.onAnalog,
    this.onButton,
    this.onTap = defaultOnTap,
    super.key,
  });

  /// The function to call when an analog control is used on this [ListTile].
  final void Function(GamepadListenerAnalogEvent event)? onAnalog;

  /// The function to call when a button is pressed on this [ListTile].
  final void Function(GamepadListenerButtonEvent event)? onButton;

  /// The title of the [ListTile].
  final Widget? title;

  /// The subtitle of the [ListTile].
  final Widget? subtitle;

  /// The function to call when the [ListTile] is tapped.
  final VoidCallback onTap;

  /// Whether the [ListTile] should be autofocused.
  final bool autofocus;

  /// Create state for this widget.
  @override
  GamepadListTileState createState() => GamepadListTileState();
}

/// State for [GamepadListTile].
class GamepadListTileState extends State<GamepadListTile> {
  /// Whether this [ListTile] is focused.
  late bool _focused;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    _focused = false;
  }

  /// Build a widget.
  @override
  Widget build(BuildContext context) {
    return GamepadListener(
      onEvent: (event) {
        if (!_focused) {
          return; // Do nothing.
        }
        switch (event) {
          case GamepadListenerAnalogEvent():
            widget.onAnalog?.call(event);
          case GamepadListenerButtonEvent():
            widget.onButton?.call(event);
        }
      },
      child: ListTile(
        autofocus: widget.autofocus,
        title: widget.title,
        subtitle: widget.subtitle,
        onTap: widget.onTap,
        onFocusChange: (value) => _focused = value,
      ),
    );
  }
}
