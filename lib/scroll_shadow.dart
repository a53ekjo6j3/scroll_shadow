library scroll_shadow;

import 'package:flutter/material.dart';

class ScrollShadow extends StatefulWidget {
  final ScrollController controller;

  final Widget child;

  final Color? shadowColor;

  final double? shadowSize;

  final Axis scrollDirection;

  final bool showEndShadow;

  final bool showStartShadow;

  const ScrollShadow({
    Key? key,
    required this.controller,
    required this.child,
    this.shadowColor,
    this.shadowSize,
    this.scrollDirection = Axis.vertical,
    this.showEndShadow = true,
    this.showStartShadow = true,
  }) : super(key: key);

  @override
  State<ScrollShadow> createState() => _ScrollShadowState();
}

class _ScrollShadowState extends State<ScrollShadow> {
  bool isOnStart = false;

  bool isOnEnd = false;

  bool shadowVisible = false;

  final duration = const Duration(milliseconds: 300);

  double get shadowSize => widget.shadowSize ?? 56;

  Color get shadowColor => widget.shadowColor ?? Colors.white;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(setShadow);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setShadow();
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(setShadow);
    super.dispose();
  }

  @override
  void didUpdateWidget(ScrollShadow oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setShadow();
    });
  }

  void setShadow() {
    if (!mounted) {
      return;
    }
    setState(() {
      if (widget.controller.position.maxScrollExtent == 0.0) {
        shadowVisible = false;
      } else {
        shadowVisible = true;
      }

      if (widget.controller.position.maxScrollExtent <=
          widget.controller.offset) {
        isOnEnd = true;
      } else {
        isOnEnd = false;
      }

      if (widget.controller.offset <= 0) {
        isOnStart = true;
      } else {
        isOnStart = false;
      }
    });
  }

  Alignment get gradientBegin => widget.scrollDirection == Axis.horizontal
      ? Alignment.centerRight
      : Alignment.bottomCenter;

  Alignment get gradientEnd => widget.scrollDirection == Axis.horizontal
      ? Alignment.centerLeft
      : Alignment.topCenter;

  BoxDecoration get startBoxDecoration => BoxDecoration(
        gradient: LinearGradient(
          begin: gradientBegin,
          end: gradientEnd,
          colors: isOnStart
              ? [
                  shadowColor.withOpacity(0),
                  shadowColor.withOpacity(0),
                ]
              : [
                  shadowColor.withOpacity(0),
                  shadowColor.withOpacity(shadowVisible ? 1.0 : 0),
                ],
        ),
      );

  BoxDecoration get endBoxDecoration => BoxDecoration(
        gradient: LinearGradient(
          begin: gradientBegin,
          end: gradientEnd,
          colors: isOnEnd
              ? [
                  shadowColor.withOpacity(0),
                  shadowColor.withOpacity(0),
                ]
              : [
                  shadowColor.withOpacity(shadowVisible ? 1.0 : 0),
                  shadowColor.withOpacity(0),
                ],
        ),
      );

  Widget buildStart() {
    if (!widget.showStartShadow) {
      return Container();
    }
    double width = 0, height = 0;
    if (widget.scrollDirection == Axis.horizontal) {
      width = shadowSize;
      height = MediaQuery.of(context).size.height;
    } else {
      width = MediaQuery.of(context).size.width;
      height = shadowSize;
    }
    return Positioned(
      left: 0,
      top: 0,
      child: buildContainer(width, height, startBoxDecoration),
    );
  }

  Widget buildEnd() {
    if (!widget.showEndShadow) {
      return Container();
    }
    if (widget.scrollDirection == Axis.horizontal) {
      return Positioned(
        right: 0,
        top: 0,
        child: buildContainer(
          shadowSize,
          MediaQuery.of(context).size.height,
          endBoxDecoration,
        ),
      );
    } else {
      return Positioned(
        bottom: 0,
        left: 0,
        child: buildContainer(
          MediaQuery.of(context).size.width,
          shadowSize,
          endBoxDecoration,
        ),
      );
    }
  }

  Widget buildContainer(double width, double height, Decoration decoration) {
    return IgnorePointer(
      ignoring: true,
      child: AnimatedContainer(
        duration: duration,
        width: width,
        height: height,
        decoration: decoration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        buildStart(),
        buildEnd(),
      ],
    );
  }
}
