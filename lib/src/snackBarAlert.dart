import 'package:flutter/material.dart';

/// Classe responsável por chamar/exibir o widget através do objeto [SnackbarAlert]
abstract class SnackBarShow {
  static void show(
      {required BuildContext context,
      required Widget widget,
      Color backgroundColor = Colors.blueGrey,
      BorderRadiusGeometry? borderRadius,
      EdgeInsetsGeometry margin = const EdgeInsets.all(0),
      double height = 48.0,
      double width = double.infinity,
      int duration = 6000,
      int reverseDuration = 1500,
      SnackBarAlignment snackBarAlignment = SnackBarAlignment.bottom,
      void Function()? onVisible}) {
    Navigator.push(
      context,
      SnackbarAlert(
        widget: widget,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        margin: margin,
        height: height,
        width: width,
        duration: duration,
        reverseDuration: reverseDuration,
        snackBarAlignment: snackBarAlignment,
        onVisible: onVisible,
      ),
    );
  }
}

/// Chamar um widget customizável de sobreposição[Overlay] que substitui a [SnackBar] da biblioteca do [Material],
/// sem em bloquear a rota(página) ativa
class SnackbarAlert extends OverlayRoute {
  /// Exemplo de `SnackBarShow.show(context: context, widget: const MyWidget());`
  final Widget widget;
  final Color backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry margin;
  final double height;
  final double width;
  final int duration;
  final int reverseDuration;
  final SnackBarAlignment snackBarAlignment;
  final void Function()? onVisible;

  SnackbarAlert({
    required this.widget,
    this.backgroundColor = Colors.blueGrey,
    this.borderRadius,
    this.margin = const EdgeInsets.all(0),
    this.height = 48.0,
    this.width = double.infinity,
    this.duration = 6000,
    this.reverseDuration = 1500,
    this.onVisible,
    this.snackBarAlignment = SnackBarAlignment.bottom,
  }) : super(settings: const RouteSettings(name: 'SnackbarAlert'));

  late AnimationController _animationController;

  void _close() {
    /*Future.delayed(
      const Duration(milliseconds: 4000),
      (){
        if(isCurrent){
          navigator?.pop();
        }else if(isActive){
          //navigator.removeRoute(this); 
          navigator?.finalizeRoute(this);  
        }else{
          dispose();
        }
      }
    );*/
    Future.delayed(const Duration(milliseconds: 4000), dispose);
  }

  @override
  void install() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: reverseDuration),
      debugLabel: 'animationSnackBarController',
      vsync: navigator!,
    );

    onVisible?.call();

    super.install();

    Future.delayed(Duration(milliseconds: duration), () {
      if (_animationController.isCompleted) {
        _animationController.reverse();
        _close();
      }
    });
  }

  @override
  TickerFuture didPush() {
    super.didPush();
    return _animationController.forward();
  }

  @override
  void dispose() {
    print('---- Disposing SnackBar ----');

    if (_animationController.isCompleted) {
      _animationController.reverse();
      _animationController.dispose();
    } else {
      _animationController.dispose();
    }

    super.overlayEntries[0].remove();
    super.dispose();
  }

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      OverlayEntry(builder: (_) {
        return SafeArea(
          child: SlideTransition(
            position: _animationController.view.drive(
                Tween(begin: snackBarAlignment.getOffSet, end: Offset.zero)
                    .chain(CurveTween(curve: Curves.ease))),
            child: Align(
              alignment: snackBarAlignment.getAlignment,
              child: Dismissible(
                onDismissed: (direction) {
                  _animationController.reverse();
                  _close();
                },
                key: const Key("dismissibleSnackbar"),
                direction: DismissDirection.horizontal,
                child: Container(
                  margin: margin,
                  alignment: Alignment.center,
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: borderRadius ?? BorderRadius.circular(0.0),
                  ),
                  child: widget,
                ),
              ),
            ),
          ),
        );
      }),
    ];
  }
}

enum SnackBarAlignment {
  top,
  topLeftToRigth,
  topRigthToLeft,
  bottom,
  bottomLeftToRigth,
  bottomRigthToLeft,
}

/// Definir o aliamento da [SnackbarAlert]
extension on SnackBarAlignment {
  Alignment get getAlignment {
    switch (this) {
      case SnackBarAlignment.top:
      case SnackBarAlignment.topLeftToRigth:
      case SnackBarAlignment.topRigthToLeft:
        return Alignment.topCenter;
      case SnackBarAlignment.bottom:
      case SnackBarAlignment.bottomLeftToRigth:
      case SnackBarAlignment.bottomRigthToLeft:
        return Alignment.bottomCenter;
      default:
        return Alignment.bottomCenter;
    }
  }

  Offset get getOffSet {
    switch (this) {
      case SnackBarAlignment.top:
        return const Offset(0.0, -1.0);
      case SnackBarAlignment.bottom:
        return const Offset(0.0, 1.0);
      case SnackBarAlignment.topLeftToRigth:
      case SnackBarAlignment.bottomLeftToRigth:
        return const Offset(-1.0, 0.0);
      case SnackBarAlignment.topRigthToLeft:
      case SnackBarAlignment.bottomRigthToLeft:
        return const Offset(1.0, 0.0);
      default:
        return Offset(0.0, 1.0);
    }
  }
}
