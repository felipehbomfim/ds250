import 'package:flutter/material.dart';
import 'package:ds250/core/app_export.dart';
import 'package:ds250/widgets/custom_button_slider/swipeable/swipeable_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vibration/vibration.dart';


class SwipeableButtonView extends StatefulWidget {
  final VoidCallback onFinish;

  /// Event waiting for the process to finish
  final VoidCallback onWaitingProcess;

  /// Animation finish control
  final bool isFinished;

  /// Button is active value default : true
  final bool isActive;

  /// Button active color value
  final Color activeColor;

  /// Button disable color value
  final Color? disableColor;

  /// Swipe button widget
  final Widget buttonWidget;

  /// Button color default : Colors.white
  final Color? buttonColor;

  /// Button label
  final Widget? label;

  /// Button text style
  final TextStyle? buttontextstyle;

  /// Button width
  final double? buttonWidth;

  /// Height
  final double? height;

  /// Is right to left
  final bool? inverted;

  /// Show ripple effect
  final bool? showRippleEffect;

  /// Error
  final bool? error;

  /// Widget to show after finish
  final Widget? onFinishWidget;

  /// Circle indicator color
  final Animation<Color?>? indicatorColor;
  const SwipeableButtonView(
      {Key? key,
        required this.onFinish,
        required this.onWaitingProcess,
        required this.activeColor,
        required this.buttonWidget,
        this.label,
        this.isFinished = false,
        this.inverted = false,
        this.isActive = true,
        this.showRippleEffect = false,
        this.disableColor = Colors.grey,
        this.buttonColor = Colors.white,
        this.buttonWidth = 60,
        this.height = 60,
        this.error = false,
        this.onFinishWidget = null,
        this.buttontextstyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        this.indicatorColor = const AlwaysStoppedAnimation<Color>(Colors.white)
      })
      : super(key: key);

  @override
  _SwipeableButtonViewState createState() => _SwipeableButtonViewState();
}

class _SwipeableButtonViewState extends State<SwipeableButtonView>
    with TickerProviderStateMixin {
  bool isAccepted = false;
  double opacity = 1;
  bool isFinishValue = false;
  bool isStartRippleEffect = false;
  late AnimationController _controller;

  bool isScaleFinished = false;

  late AnimationController rippleController;
  late AnimationController scaleController;

  late Animation<double> rippleAnimation;
  late Animation<double> scaleAnimation;
  bool showCustomWidget = false;

  init() {
    if(mounted) {
      setState(() {
        isAccepted = false;
        opacity = 1;
        isFinishValue = false;
        isStartRippleEffect = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(mounted) {
      setState(() {
        isFinishValue = widget.isFinished;
      });
    }

    rippleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    scaleController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 800))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if(mounted) {
            setState(() {
              isFinishValue = true;
            });
          }
          widget.onFinish();
        }
      });
    rippleAnimation =
    Tween<double>(begin: 60.0, end: 90.0).animate(rippleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          rippleController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          rippleController.forward();
        }
      });
    scaleAnimation =
    Tween<double>(begin: 1.0, end: 30.0).animate(scaleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if(mounted) {
            setState(() {
              isScaleFinished = true;
            });
          }
        }
      });

    //rippleController.forward();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..addListener(() {
        if(mounted){
          setState(() {});
        }
      })
      ..addStatusListener((status) {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    rippleController.dispose();
    scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.error!){
      scaleController.reverse().then((value) {
        init(); // Restaura os estados para permitir uma nova ação
      });
    }else{
      if (widget.isFinished) {
        if(mounted){
          setState(() {
            isStartRippleEffect = true;
            isFinishValue = true;
          });
        }
        scaleController.forward().then((_) {
          // Adiciona um delay após a animação completar
          Future.delayed(Duration(seconds: 2), () { // Ajuste o tempo conforme necessário
            if(mounted){
              setState(() {
                // Atualize o estado para refletir que a ação foi concluída
                // Isso pode incluir esconder o loader ou resetar estados
              });
            }
            widget.onFinish(); // Chame isso após o delay
          });
        });
      } else {
        if (isFinishValue) {
          scaleController.reverse().then((value) {
            init(); // Restaura os estados para permitir uma nova ação
          });
        }
      }
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double alignmentValue = screenWidth > 400 ? 0.6 : 0.7;
    return Container(
      width: isAccepted
          ? (MediaQuery.of(context).size.width -
          ((MediaQuery.of(context).size.width - 40) * _controller.value))
          : double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
          color: widget.isActive ? widget.activeColor : widget.disableColor,
          borderRadius: BorderRadius.circular(30)),
      child: Stack(
        children: [
          Align(
            alignment: widget.inverted! ? Alignment(-alignmentValue, 0) : Alignment(alignmentValue, 0),
            child: Opacity(
              opacity: opacity,
              child: Shimmer.fromColors(
                baseColor: colorGrey,
                highlightColor: Colors.white,
                child: widget.label ?? Text(''),
              ),
            ),
          ),
          !isAccepted
              ? SwipeableWidget(
            isActive: widget.isActive,
            inverted: widget.inverted!,
            height: widget.height ?? 60,
            buttonWidth: widget.buttonWidth ?? 60,
            onSwipeValueCallback: (value) {
              setState(() {
                opacity = value;
              });
            },
            child: Container(
              padding: EdgeInsets.only(left: 2, right: 2),
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.start,
                children: [
                  Container(
                    width: widget.buttonWidth,
                    height: widget.height! - 5,
                    child: Center(
                      child: widget.buttonWidget,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: widget.buttonColor
                      // color: Colors.transparent
                    ),
                  )
                ],
              ),
              height: 60.0,
            ),
            onSwipeCallback: () async {
              widget.onWaitingProcess();
              setState(() {
                isAccepted = true;
              });
              final hasVibrator = await Vibration.hasVibrator() ?? false;
              if (hasVibrator) {
                try {
                  Vibration.vibrate(duration: 200);
                } catch (e) {
                  print(e);
                }
              }
              _controller.animateTo(1.0,
                  duration: Duration(milliseconds: 600),
                  curve: Curves.fastOutSlowIn);

              Future.delayed(Duration(milliseconds: 2000), () {
                if(mounted){
                  setState(() {
                    showCustomWidget = true;
                  });
                }
              });
            },
            ) : widget.showRippleEffect == true ? AnimatedBuilder(
              animation: rippleAnimation,
              builder: (context, child) => Container(
                width: rippleAnimation.value,
                height: rippleAnimation.value,
                child: AnimatedBuilder(
                  animation: scaleAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: scaleAnimation.value,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.activeColor.withOpacity(0.4),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Container(
                            child: Center(
                              child: showCustomWidget && widget.onFinishWidget != null ? widget.onFinishWidget : CircularProgressIndicator(
                                  valueColor:
                                  widget.indicatorColor
                              ),
                            ),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.isActive
                                    ? widget.activeColor
                                    : widget.disableColor
                            )
                        ),
                      ),
                    ),
                  )),
            ),
          ) : Container(
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.activeColor.withOpacity(0.4),
            ),
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: AnimatedContainer(
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                  child: Center(
                    child: showCustomWidget && widget.onFinishWidget != null ? widget.onFinishWidget : CircularProgressIndicator(
                        valueColor:
                        widget.indicatorColor
                    ),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isActive
                          ? widget.activeColor
                          : widget.disableColor
                  )
              ),
            ),
          )
        ],
      ),
    );
  }
}
