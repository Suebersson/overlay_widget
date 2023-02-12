import 'dart:async';
import 'package:flutter/material.dart';

/// Exemplo de `SnackBarShow.show(context: context, widget: const MyWidget());`
class SnackbarAlert extends OverlayRoute {
  /// Chamar um widget customizável de sobreposição[Overlay] que substitui a [SnackBar] da biblioteca do [Material],
  /// sem em bloquear a rota(página) ativa que possibilita ao desenvolvedor uma maior customização
  final Widget child;
  final TypeAnimation typeAnimation;
  final Duration duration;
  final Duration animationReverse;
  final Curve curve;
  final SnackBarAlignment snackBarAlignment;
  final void Function()? onVisible;
  final void Function()? onClosing;

  SnackbarAlert({
    required this.child,
    this.typeAnimation = TypeAnimation.slide,
    this.duration = const Duration(seconds: 6),
    this.animationReverse = const Duration(milliseconds: 2000),
    this.curve = Curves.linear,
    this.snackBarAlignment = SnackBarAlignment.bottom,
    this.onVisible,
    this.onClosing,
  }) : super(settings: const RouteSettings(name: 'SnackbarAlert'));

  late final AnimationController _animationController;
  bool _canDispose = true;
  bool _disposed = false;

  static void show(
      {required BuildContext context,
      required Widget child,
      TypeAnimation typeAnimation = TypeAnimation.slide,
      Duration duration = const Duration(seconds: 6),
      Duration animationReverse = const Duration(milliseconds: 2000),
      Curve curve = Curves.linear,
      SnackBarAlignment snackBarAlignment = SnackBarAlignment.bottom,
      void Function()? onVisible,
      void Function()? onClosing}) {
    Navigator.push(
      context,
      SnackbarAlert(
        child: child,
        typeAnimation: typeAnimation,
        duration: duration,
        animationReverse: animationReverse,
        curve: curve,
        snackBarAlignment: snackBarAlignment,
        onVisible: onVisible,
        onClosing: onClosing,
      ),
    );
  }

  @override
  void install() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      reverseDuration: animationReverse,
      debugLabel: 'animationSnackBarController',
      vsync: navigator!,
    );

    onVisible?.call();

    int durationCounter = duration.inSeconds;

    /// Função para contagem regressiva da duração de exibição da Snackbar
    /// que pausa a contagem quando o usuário tocar e manter pressionado o widget
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_disposed) {
        timer.cancel();
      } else if (_canDispose && durationCounter <= 0) {
        timer.cancel();
        overlayClose();
      } else if (_canDispose) {
        durationCounter--;
      }
    });

    super.install();
  }

  @override
  TickerFuture didPush() {
    super.didPush();
    return _animationController.forward();
  }

  void overlayClose() async {
    _disposed = true;

    onClosing?.call();

    await _animationController.reverse();

    //navigator?.pop();
    navigator?.removeRoute(this);
  }

  @override
  void dispose() async {
    // debugPrint('---- Disposing SnackBar ----');

    if (_disposed) {
      _animationController.dispose();
    } else {
      _disposed = true;
      onClosing?.call();
      await _animationController.reverse();
      _animationController.dispose();
    }

    super.overlayEntries.first.dispose();
    super.dispose();
  }

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      OverlayEntry(builder: (context) {
        return SafeArea(
          child: _SelectedSnackbarAnimation(
            snackbarAlert: this,
            child: Align(
              alignment: snackBarAlignment.getAlignment,
              child: Dismissible(
                onDismissed: (_) => overlayClose(),
                key: const Key("dismissibleSnackbar"),
                direction: DismissDirection.horizontal,
                child: GestureDetector(
                  onTapUp: (_) => _canDispose = true,
                  onLongPressUp: () => _canDispose = true,
                  onTapDown: (_) => _canDispose = false,
                  child: child,
                ),
              ),
            ),
          ),
        );
      }),
    ];
  }
}

enum TypeAnimation {
  slide,
  scale,
  fade,
  slideWithScale,
  fadeWithScale,
}

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
        return const SizedBox.shrink();
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

/// Exemplo de uma `Snackbar`
class SnackbarDemo extends StatelessWidget {
  const SnackbarDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 48.0,
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Customizable SnackBar',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Builder(builder: (context) {
              return TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
