import 'dart:async';
import 'package:flutter/material.dart';

///  Classe responsável por chamar/exibir o widget através do objeto [SnackbarAlert]
abstract class SnackBarShow {
  static void show(
      {required BuildContext context,
      required Widget widget,
      TypeAnimation typeAnimation = TypeAnimation.slide,
      Duration duration = const Duration(seconds: 6),
      Duration animationDisplay = const Duration(milliseconds: 700),
      Duration animationReverse = const Duration(milliseconds: 1500),
      Curve curve = Curves.ease,
      SnackBarAlignment snackBarAlignment = SnackBarAlignment.bottom,
      void Function()? onVisible,
      void Function()? onClosing,
      void Function()? onTap}) {
    Navigator.push(
      context,
      SnackbarAlert(
        widget: widget,
        typeAnimation: typeAnimation,
        duration: duration,
        animationDisplay: animationDisplay,
        animationReverse: animationReverse,
        curve: curve,
        snackBarAlignment: snackBarAlignment,
        onVisible: onVisible,
        onClosing: onClosing,
        onTap: onTap,
      ),
    );
  }
}

/// Exemplo de `SnackBarShow.show(context: context, widget: const MyWidget());`
class SnackbarAlert extends OverlayRoute {
  /// Chamar um widget customizável de sobreposição[Overlay] que substitui a [SnackBar] da biblioteca do [Material],
  /// sem em bloquear a rota(página) ativa que possibilita ao desenvolvedor uma maior customização
  final Widget widget;
  final TypeAnimation typeAnimation;
  final Duration duration;
  final Duration animationDisplay;
  final Duration animationReverse;
  final Curve curve;
  final SnackBarAlignment snackBarAlignment;
  final void Function()? onVisible;
  final void Function()? onClosing;
  final void Function()? onTap;

  SnackbarAlert({
    required this.widget,
    this.typeAnimation = TypeAnimation.slide,
    this.duration = const Duration(seconds: 6),
    this.animationDisplay = const Duration(milliseconds: 700),
    this.animationReverse = const Duration(milliseconds: 1500),
    this.curve = Curves.ease,
    this.snackBarAlignment = SnackBarAlignment.bottom,
    this.onVisible,
    this.onClosing,
    this.onTap,
  }) : super(settings: const RouteSettings(name: 'SnackbarAlert'));

  late AnimationController _animationController;
  bool _canDispose = true;

  @override
  void install() {
    _animationController = AnimationController(
      duration: animationDisplay,
      reverseDuration: animationReverse,
      debugLabel: 'animationSnackBarController',
      vsync: navigator!,
    );

    onVisible?.call();

    super.install();

    int durationCounter = duration.inSeconds;

    /// Função para contagem regressiva da duração de exibição da Snackbar
    /// que pausa a contagem quando o usuário tocar e manter pressionado o widget
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_canDispose && durationCounter <= 0) {
        timer.cancel();
        if (_animationController.isCompleted) {
          _animationController.reverse().then((_) {
            Future.delayed(
                Duration(milliseconds: animationReverse.inMilliseconds + 500),
                dispose);
          });
        } else {
          dispose();
        }
      } else if (_canDispose) {
        durationCounter--;
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
    //print('---- Disposing SnackBar ----');

    onClosing?.call();

    if (_animationController.isCompleted) {
      _animationController.reverse().then((_) {
        _animationController.dispose();
      });
    } else {
      try {
        _animationController.dispose();
      } catch (e) {
        //throw '---- Controller disposed ----';
      }
    }

    if (super.overlayEntries.isNotEmpty) super.overlayEntries[0].remove();

    super.dispose();
  }

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      OverlayEntry(builder: (_) {
        return SafeArea(
          child: _SelectedSnackbarAnimation(
            snackbarAlert: this,
            child: Align(
              alignment: snackBarAlignment.getAlignment,
              child: Dismissible(
                onDismissed: (_) => dispose(),
                key: const Key("dismissibleSnackbar"),
                direction: DismissDirection.horizontal,
                child: GestureDetector(
                  onTapUp: (_) => _canDispose = true,
                  onLongPressUp: () => _canDispose = true,
                  onTapDown: (_) => _canDispose = false,
                  onTap: onTap,
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

enum TypeAnimation { slide, scale, fade, slideWithScale, fadeWithScale }

@immutable
class _SelectedSnackbarAnimation extends StatelessWidget {
  final SnackbarAlert snackbarAlert;
  final Widget child;

  const _SelectedSnackbarAnimation({
    Key? key,
    required this.snackbarAlert,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (snackbarAlert.typeAnimation) {
      case TypeAnimation.slide:
        return SlideTransition(
          position: snackbarAlert._animationController.view.drive(Tween(
                  begin: snackbarAlert.snackBarAlignment.getOffSet,
                  end: Offset.zero)
              .chain(CurveTween(curve: snackbarAlert.curve))),
          child: child,
        );
      case TypeAnimation.scale:
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: snackbarAlert._animationController,
              curve: snackbarAlert.curve)),
          alignment: Alignment.center,
          child: child,
        );
      case TypeAnimation.fade:
        return FadeTransition(
          child: child,
          opacity: snackbarAlert._animationController,
        );
      case TypeAnimation.slideWithScale:
        return SlideTransition(
          position: snackbarAlert._animationController.drive(Tween(
                  begin: snackbarAlert.snackBarAlignment.getOffSet,
                  end: Offset.zero)
              .chain(CurveTween(curve: snackbarAlert.curve))),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: snackbarAlert._animationController,
                curve: snackbarAlert.curve)),
            child: child,
          ),
        );
      case TypeAnimation.fadeWithScale:
        return FadeTransition(
          opacity: snackbarAlert._animationController,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: snackbarAlert._animationController,
                curve: snackbarAlert.curve)),
            child: child,
            alignment: Alignment.center,
          ),
        );
      default:
        return const SizedBox();
    }
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
        return const Offset(0.0, 1.0);
    }
  }
}
