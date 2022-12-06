import 'package:flutter/material.dart' hide BoxShadow, BoxDecoration;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class NeumorphicContainer extends StatefulWidget {
  const NeumorphicContainer({
    this.onTap,
    super.key,
    required this.child,
  })  : selected = false,
        selectableMode = false;

  const NeumorphicContainer.selectable({
    super.key,
    this.onTap,
    required this.child,
    required this.selected,
  }) : selectableMode = true;

  final Function()? onTap;
  final Widget child;
  final bool selectableMode;
  final bool selected;

  @override
  State<NeumorphicContainer> createState() => _NeumorphicContainerState();
}

class _NeumorphicContainerState extends State<NeumorphicContainer> {
  Function(TapDownDetails)? tapDown() {
    if (!disabled) {
      return (details) {
        state = ButtonState.tapped;
        setState(() {});
      };
    }

    return null;
  }

  Function(TapUpDetails)? tapUp() {
    if (!disabled) {
      return (details) {
        if (!state.isSelected) {
          state = ButtonState.hovered;
          setState(() {});
        }
      };
    }
    return null;
  }

  Function(PointerExitEvent)? exit() {
    if (!disabled) {
      return (event) {
        if (state.isHovering) {
          state = ButtonState.none;
          setState(() {});
        }
      };
    }
    return null;
  }

  Function(PointerEnterEvent)? entered() {
    if (!disabled) {
      return (event) {
        state = ButtonState.hovered;
        setState(() {});
      };
    }
    return null;
  }

  late bool disabled;
  late ButtonState state = ButtonState.none;

  Function()? tap() {
    if (widget.selectableMode) {
      state = ButtonState.selected;
      setState(() {});
      return widget.onTap?.call();
    } else {
      return widget.onTap?.call();
    }
  }

  Offset getOffset(bool isNegative) {
    final offsetMap = {
      ButtonState.hovered:
          isNegative ? const Offset(-8, -8) : const Offset(8, 8),
      ButtonState.tapped:
          isNegative ? const Offset(-5, -5) : const Offset(5, 5),
      ButtonState.disabled:
          isNegative ? const Offset(-1, -1) : const Offset(1, 1),
      ButtonState.none: isNegative ? const Offset(-4, -4) : const Offset(4, 4),
    };
    return offsetMap[state] ??
        (isNegative ? const Offset(-4, -4) : const Offset(4, 4));
  }

  @override
  void initState() {
    super.initState();
    if (widget.onTap == null) {
      state = ButtonState.disabled;
    }

    disabled = state.isDisabled;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      onTapDown: tapDown.call(),
      onTapUp: tapUp.call(),
      child: MouseRegion(
        onEnter: entered.call(),
        onExit: exit.call(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade500,
                offset: getOffset(false),
                blurRadius: 15,
                spreadRadius: 1,
                inset: widget.selected,
              ),
              BoxShadow(
                color: Colors.white,
                offset: getOffset(true),
                blurRadius: 15,
                spreadRadius: 1,
                inset: widget.selected,
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

enum ButtonState {
  hovered,
  tapped,
  disabled,
  selected,

  none;

  bool get isHovering => this == ButtonState.hovered;
  bool get isTapped => this == ButtonState.tapped;
  bool get isDisabled => this == ButtonState.disabled;
  bool get isSelected => this == ButtonState.selected;
  bool get isNone => this == ButtonState.none;
}
