import 'package:flutter/material.dart';

/// Chamar um widget flutuante customizável de sobreposição[Overlay]
/// sem em bloquear a rota(página) ativa
///
class FloatingWidgetAlert extends OverlayRoute {
  final Widget widget;
  Offset? offset;
  final Duration? duration;
  final void Function()? onClick;
  final void Function()? onVisible;
  final void Function()? onClosing;

  FloatingWidgetAlert({
    required this.widget,
    this.offset,
    this.duration,
    this.onClick,
    this.onVisible,
    this.onClosing,
  }) : super(settings: const RouteSettings(name: 'FloatingWidgetAlert'));

  /// Chamar/exibir a widget [FloatingWidgetAlert]
  static void show({
    required BuildContext context,
    required Widget widget,
    Offset? offset,
    final Duration? duration,
    void Function()? onClick,
    final void Function()? onVisible,
    void Function()? onClosing,
  }) {
    Navigator.push(
      context,
      FloatingWidgetAlert(
        widget: widget,
        offset: offset,
        duration: duration,
        onClick: onClick,
        onVisible: onVisible,
        onClosing: onClosing,
      ),
    );
  }

  @override
  void install() {
    super.install();

    onVisible?.call();

    if (duration != null) Future.delayed(duration!, overlayClose);
  }

  void overlayClose() {
    onClosing?.call();

    //navigator?.pop();
    navigator?.removeRoute(this);

    // if(isCurrent){
    //   navigator?.pop();
    // }else if(isActive){
    //   //navigator?.removeRoute(this);
    //   navigator?.finalizeRoute(this);
    // }
  }

  @override
  void dispose() {
    // debugPrint('---- Disposing FloatingWidget ----');

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
          final Size size = MediaQuery.sizeOf(context);
          offset ??= Offset(size.width - 110, size.height - 98);
          //print(size.width);
          //print(size.height);
          return Positioned(
            left: offset!.dx,
            top: offset!.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                //offset += details.delta; // não permite fazer a soma se o operando pode ser nulo
                offset = offset! + details.delta;

                //print('${offset!.dx}  ${offset!.dy}');
                //print('${details.globalPosition.dx}');

                if (super.overlayEntries.isNotEmpty) {
                  super.overlayEntries.first.markNeedsBuild(); // setState
                }

                if (offset!.dx < 0 || offset!.dy < 0) overlayClose();
              },
              onLongPress: overlayClose,
              onTap: onClick,
              child: widget,
            ),
          );
        },
      ),
    ];
  }
}
