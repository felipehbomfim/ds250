import 'package:flutter/material.dart';

class SwipeableWidget extends StatefulWidget {
  /// The `Widget` on which we want to detect the swipe movement.
  final Widget child;

  /// The Height of the widget that will be drawn, required.
  final double height;

  /// The Height of the widget that will be drawn, required.
  final double buttonWidth;

  /// The `VoidCallback` that will be called once a swipe with certain percentage is detected.
  final VoidCallback onSwipeCallback;

  final SwipeValueCallBack onSwipeValueCallback;

  /// The decimal percentage of swiping in order for the callbacks to get called, defaults to 0.75 (75%) of the total width of the children.
  final double swipePercentageNeeded;

  final bool isActive;

  final bool inverted;

  SwipeableWidget(
      {Key? key,
        required this.child,
        required this.height,
        required this.onSwipeCallback,
        required this.onSwipeValueCallback,
        required this.isActive,
        required this.buttonWidth,
        required this.inverted,
        this.swipePercentageNeeded = 0.75})
      : assert(child != null &&
      onSwipeCallback != null &&
      swipePercentageNeeded <= 1.0),
        super(key: key);

  @override
  _SwipeableWidgetState createState() => _SwipeableWidgetState();
}

class _SwipeableWidgetState extends State<SwipeableWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  var _dxStartPosition = 0.0;
  var _dxEndsPosition = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      });


    WidgetsBinding.instance.addPostFrameCallback((_) {
      final widgetSize = context.size!.width;
      final swipeValue = (widget.buttonWidth + 4) / widgetSize;
      _controller.value = widget.inverted ? swipeValue : 1.0;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanStart: (details) {
          setState(() {
            _dxStartPosition = details.localPosition.dx * 0.25;
          });
        },
        onPanUpdate: (details) {
          if (widget.isActive) {
            final widgetSize = context.size!.width;
            final minimumXToStartSwiping = widgetSize * 0.25;
            if (_dxStartPosition <= minimumXToStartSwiping) {
              setState(() {
                _dxEndsPosition = details.localPosition.dx;
              });

              final widgetSize = context.size!.width;
              final swipeValue = (widget.buttonWidth + 4) / widgetSize;
              final lastSize = widgetSize;
              final val = 1 - ((details.localPosition.dx) / lastSize);
              _controller.value = val < swipeValue ? swipeValue : val;

              if(!widget.inverted)
                widget.onSwipeValueCallback(_controller.value - swipeValue);
              else{
                double valueToDecrease = _controller.value - 1.0;

                widget.onSwipeValueCallback(valueToDecrease.abs());
              }
            }
          }
        },
        onPanEnd: (details) async {
          if (widget.isActive) {
            final delta = widget.inverted ? _dxStartPosition - _dxEndsPosition : _dxEndsPosition - _dxStartPosition;
            final widgetSize = context.size!.width;
            var deltaNeededToBeSwiped = widgetSize * widget.swipePercentageNeeded;
            deltaNeededToBeSwiped -= widget.inverted ? 180.0 : 60.0;
            final swipeValue = 60.0 / widgetSize;

            if (delta > deltaNeededToBeSwiped) {
              _controller.animateTo(swipeValue,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn);
              widget.onSwipeCallback();
            } else {
              final widgetSize = context.size!.width;
              final swipeValue = (widget.buttonWidth + 4) / widgetSize;
              double valueToGo = widget.inverted ? swipeValue : 1.0;
              _controller.animateTo(valueToGo, duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
              widget.onSwipeValueCallback(valueToGo);
            }
          }
        },
        child: Container(
          height: widget.height,
          child: Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: _controller.value,
              heightFactor: 1.0,
              child: widget.child,
            ),
          ),
        ));
  }
}

typedef SwipeValueCallBack(double value);
