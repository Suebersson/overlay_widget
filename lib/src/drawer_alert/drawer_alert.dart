import 'package:flutter/material.dart';

part './alignment.dart';
part './drawer_demo.dart';

/// Chamar um widget customizável de sobreposição[Overlay] que substitui a
/// `Drawer` da biblioteca [Material], sem em bloquear a rota(página) ativa
/// que possibilita ao desenvolvedor uma maior customização
///
class DrawerAlert extends OverlayRoute {
  final Widget child;
  final double width;
  final Duration transitionTime;
  final DrawerAlertAlignment alignment;
  final void Function()? onVisible;
  final void Function()? onClosing;

  DrawerAlert({
    required this.child,
    this.width = 304.0,
    this.transitionTime = const Duration(milliseconds: 500),
    this.alignment = DrawerAlertAlignment.leftToRigth,
    this.onVisible,
    this.onClosing,
  }) : super(settings: const RouteSettings(name: 'DrawerAlert'));

  late final Animation<double> _animation;
  late final AnimationController _animationController;

  /// Exibir a [DrawerAlert]
  static void show({
    required BuildContext context,
    required Widget child,
    Duration transitionTime = const Duration(milliseconds: 500),
    DrawerAlertAlignment alignment = DrawerAlertAlignment.leftToRigth,
    void Function()? onVisible,
    void Function()? onClosing,
  }) {
    Navigator.push(
      context,
      DrawerAlert(
        child: child,
        transitionTime: transitionTime,
        alignment: alignment,
        onVisible: onVisible,
        onClosing: onClosing,
      ),
    );
  }

  void overlayClose() async {
    await _animationController.reverse();

    onClosing?.call();

    //navigator?.pop();
    navigator?.removeRoute(this);
  }

  @override
  void install() {
    _animationController = AnimationController(
      duration: transitionTime,
      reverseDuration: transitionTime,
      debugLabel: 'animationDrawerController',
      vsync: navigator!,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
        reverseCurve: Curves.linear,
      ),
    );

    onVisible?.call();

    super.install();
  }

  @override
  TickerFuture didPush() {
    super.didPush();
    return _animationController.forward();
  }

  @override
  void dispose() {
    // debugPrint('---- Disposing DrawerAlert ----');

    _animationController.dispose();

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
      OverlayEntry(
        builder: (context) {
          return SlideTransition(
            position: Tween(
              begin: Offset(
                alignment == DrawerAlertAlignment.leftToRigth ? -1.0 : 1.0,
                0.0,
              ),
              end: Offset.zero,
            ).animate(_animation),
            child: Dismissible(
              onDismissed: (_) => overlayClose(),
              key: const Key("DrawerAlert"),
              direction: DismissDirection.horizontal,
              child: Stack(
                alignment: alignment == DrawerAlertAlignment.leftToRigth
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                children: [
                  GestureDetector(
                    onTap: overlayClose,
                    child: const SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: ColoredBox(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: double.infinity,
                    width: width,
                    child: child,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ];
  }
}
