import 'package:flutter/material.dart';
import 'package:gamepad_event_listener/gamepad_event_listener.dart';

/// The default `onTap`.
void defaultOnTap() {}

/// A [ListTile] which responds to [GamepadListenerEvent]s when it is focused.
class GamepadFocus extends StatefulWidget {
  /// Create an instance.
  const GamepadFocus({
    required this.child,
    this.onAnalog,
    this.onButton,
    this.focusNode,
    this.parentNode,
    this.canRequestFocus = false,
    this.autofocus = false,
    this.skipTraversal,
    this.descendantsAreFocusable,
    this.descendantsAreTraversable,
    this.includeSemantics = true,
    this.debugLabel,
    super.key,
  });

  /// The child below this widget in the tree.
  final Widget child;

  /// The function to call when an analog control is used on this [ListTile].
  final void Function(GamepadListenerAnalogEvent event)? onAnalog;

  /// The function to call when a button is pressed on this [ListTile].
  final void Function(GamepadListenerButtonEvent event)? onButton;

  /// The focus node to use.
  final FocusNode? focusNode;

  /// The parent focus node.
  final FocusNode? parentNode;

  /// Whether the [Focus] widget can request focus.
  final bool? canRequestFocus;

  /// Whether to skip traversal.
  final bool? skipTraversal;

  /// Whether the descendents of the [Focus] widget should be focusable.
  final bool? descendantsAreFocusable;

  /// Whether the descendents of the [Focus] widget should be traversable.
  final bool? descendantsAreTraversable;

  /// Whether the [Focus] widget should be autofocused.
  final bool autofocus;

  /// Whether to include semantics.
  final bool includeSemantics;

  /// The debug label to use.
  final String? debugLabel;

  /// Create state for this widget.
  @override
  GamepadFocusState createState() => GamepadFocusState();
}

/// State for [GamepadFocus].
class GamepadFocusState extends State<GamepadFocus> {
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
    return Focus(
      autofocus: widget.autofocus,
      canRequestFocus: widget.canRequestFocus,
      debugLabel: widget.debugLabel ?? 'GamepadFocus',
      descendantsAreFocusable: widget.descendantsAreFocusable,
      descendantsAreTraversable: widget.descendantsAreTraversable,
      focusNode: widget.focusNode,
      parentNode: widget.parentNode,
      includeSemantics: widget.includeSemantics,
      onFocusChange: (value) => _focused = value,
      child: GamepadListener(
        child: widget.child,
        onAnalog: (event) {
          if (!_focused) {
            return;
          }
          widget.onAnalog?.call(event);
        },
        onButton: (event) {
          if (!_focused) {
            return;
          }
          widget.onButton?.call(event);
        },
      ),
    );
  }
}
