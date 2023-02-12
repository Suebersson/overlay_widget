import 'package:flutter/material.dart';

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
  static void show(
      {required BuildContext context,
      required Widget child,
      Duration transitionTime = const Duration(milliseconds: 500),
      DrawerAlertAlignment alignment = DrawerAlertAlignment.leftToRigth,
      void Function()? onVisible,
      void Function()? onClosing}) {
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
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
      reverseCurve: Curves.linear,
    ));

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
    super.overlayEntries.first.dispose();
    super.dispose();
  }

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      OverlayEntry(builder: (context) {
        return SlideTransition(
          position: Tween(
                  begin: Offset(
                      alignment == DrawerAlertAlignment.leftToRigth
                          ? -1.0
                          : 1.0,
                      0.0),
                  end: Offset.zero)
              .animate(_animation),
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
                    )),
                SizedBox(
                  height: double.infinity,
                  width: width,
                  child: child,
                ),
              ],
            ),
          ),
        );
      }),
    ];
  }
}

enum DrawerAlertAlignment {
  leftToRigth,
  rigthToLeft,
}

/// Widget exemplo para criar uma drawer
class DrawerDemo extends StatelessWidget {
  const DrawerDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueGrey,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0, left: 15, bottom: 8.0),
              child: Text('Drawer demo',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
            const Divider(color: Colors.white, height: 3.5),
            Expanded(
              child: Container(
                color: Colors.blueGrey[400],
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5.0),
                alignment: Alignment.center,
                child: const Text('seus widgets',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
