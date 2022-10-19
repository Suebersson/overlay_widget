import 'package:flutter/material.dart';

/// Chamar um widget customizavel de sobreposição(overlay) semelhante a uma Toast nativa do android.
/// O Widget [ToastAlert] pode ser chamado diretamente pela classe ou pelo método [Toast.show]
abstract class Toast {
  /// Exemplo de uso: Toast.show(context: context, message: 'My toast');
  static void show({
    required BuildContext context,
    required child,
    Color backgroundColor = Colors.black54,
    Duration duration = const Duration(milliseconds: 3500),
    ToastAlignment toastAlignment = ToastAlignment.bottom,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry margin =
        const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
    EdgeInsetsGeometry padding = const EdgeInsets.all(7.0),
  }) {
    Navigator.push(
      context,
      ToastAlert(
        child: child,
        backgroundColor: backgroundColor,
        duration: duration,
        toastAlignment: toastAlignment,
        borderRadius: borderRadius,
        margin: margin,
        padding: padding,
      ),
    );
  }
}

class ToastAlert extends OverlayRoute {
  /// Navegar para um [Widget] de sobreposição semelhante a uma Toast do tipo [Overlay]
  /// sem bloquear a rota(página) ativa
  final Text child;
  final Color backgroundColor;
  final Duration duration;
  final ToastAlignment toastAlignment;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  ToastAlert({
    required this.child,
    this.backgroundColor = Colors.black54,
    this.duration = const Duration(milliseconds: 3500),
    this.toastAlignment = ToastAlignment.bottom,
    this.borderRadius,
    this.margin = const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
    this.padding = const EdgeInsets.all(7.0),
  }) : super(settings: const RouteSettings(name: 'ToastAlert'));

  late AnimationController _animationController;

  @override
  void install() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      reverseDuration: duration,
      debugLabel: 'animationToastController',
      vsync: navigator!,
    );

    super.install();

    Future.delayed(duration, () {
      _animationController.reverse().then((_) {
        Future.delayed(const Duration(seconds: 2), dispose);
      });
    });
  }

  @override
  TickerFuture didPush() {
    super.didPush();
    return _animationController.forward();
  }

  @override
  void dispose() {
    //print('---- Disposing Toast ----');
    _animationController.dispose();
    super.overlayEntries[0].remove();
    super.dispose();
  }

  /// Desse widget prá baixo deve ser evitados usar um Container
  /// porque ele tem o comportamento de se expandir oculpando o resto
  /// da largura disponivel na tela mesmo quando o texto for pequeno.
  ///
  /// Dessa forma o [Material] substítui o [Container] e será sempre
  /// compactado, com quebra de linha e limitado a largura da tela
  ///
  /// Componentes nessa ordem:
  ///
  /// Padding
  /// Center
  /// Material
  /// Padding
  /// child: Text()
  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      OverlayEntry(builder: (context) {
        return SafeArea(
          child: FadeTransition(
            opacity: _animationController.view,
            child: FittedBox(
              alignment: toastAlignment.getAlignment,
              fit: BoxFit.none,
              child: LimitedBox(
                maxWidth: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: margin,
                  child: Center(
                    child: Material(
                      color: backgroundColor,
                      borderRadius: borderRadius ?? BorderRadius.circular(5.0),
                      child: Padding(
                        padding: padding,
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    ];
  }
}

enum ToastAlignment { top, center, bottom }

extension on ToastAlignment {
  Alignment get getAlignment {
    switch (this) {
      case ToastAlignment.top:
        return Alignment.topCenter;
      case ToastAlignment.center:
        return Alignment.center;
      case ToastAlignment.bottom:
        return Alignment.bottomCenter;
      default:
        return Alignment.center;
    }
  }
}
