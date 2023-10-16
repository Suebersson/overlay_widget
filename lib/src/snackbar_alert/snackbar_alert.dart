import 'dart:async';
import 'package:flutter/material.dart';

part './alignment.dart';
part './animations.dart';
part './snackbar_demo.dart';
part './type_animation.dart';

/// Exemplo de como usar `SnackbarAlert.show(context: context, widget: const SnackbarDemo());`
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

  /// Exemplo de como usar
  ///
  /// SnackbarAlert.show(
  ///   context: context,
  ///   child: const SnackbarDemo()
  /// );
  ///
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

    super.dispose();

    // if (overlayEntries.isNotEmpty) {
    //   // A overlay ainda(mounted) está na árvore de widget
    //   if (overlayEntries.first.mounted) {
    //     debugPrint('Quantidade de overlays na árvore: ${overlayEntries.length}');
    //     overlayEntries.first.dispose();
    //  // super.overlayEntries.first.remove();
    //   }
    // }
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
