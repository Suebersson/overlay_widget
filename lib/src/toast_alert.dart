import 'package:flutter/material.dart';

/// Navegar para um [Widget] de sobreposição semelhante a uma `Toast` do tipo [Overlay]
/// sem bloquear a rota(página) ativa
class ToastAlert extends OverlayRoute {
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
    this.duration = const Duration(milliseconds: 4000),
    this.toastAlignment = ToastAlignment.bottom,
    this.borderRadius,
    this.margin = const EdgeInsets.symmetric(vertical: 30.0, horizontal: 15.0),
    this.padding = const EdgeInsets.all(7.0),
  }) : super(settings: const RouteSettings(name: 'ToastAlert'));

  late final AnimationController _animationController;

  /// Exibir uma widget customizavel de sobreposição(overlay) semelhante a uma `Toast` nativa do android.
  /// A Widget [ToastAlert] pode ser chamado diretamente pela classe ou pelo método [ToastAlert.show]
  static void show({
    // Exemplo de uso: Toast.show(context: context, message: 'My toast');
    required BuildContext context,
    required Text child,
    Color backgroundColor = Colors.black54,
    Duration duration = const Duration(milliseconds: 4000),
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

  @override
  void install() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      reverseDuration: duration,
      debugLabel: 'animationToastController',
      vsync: navigator!,
    );

    super.install();

    Future<void>.delayed(duration, overlayClose);
  }

  @override
  TickerFuture didPush() {
    super.didPush();
    return _animationController.forward();
  }

  void overlayClose() async {
    await _animationController.reverse();

    //navigator?.pop();
    navigator?.removeRoute(this);
  }

  @override
  void dispose() {
    // debugPrint('---- Disposing Toast ----');
    _animationController.dispose();
    super.overlayEntries.first.dispose();
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
