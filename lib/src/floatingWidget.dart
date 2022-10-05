import 'package:flutter/widgets.dart';

/// Classe responsável por chamar/exibir o widget através do objeto [FloatingWidgetAlert]
abstract class FloatingWidget {
  static void show(
      {required BuildContext context,
      required Widget widget,
      Offset? offset,
      final Duration? duration,
      void Function()? onClick,
      final void Function()? onVisible,
      void Function()? onClosing}) {
    Navigator.push(
      context,
      FloatingWidgetAlert(
          widget: widget,
          offset: offset,
          duration: duration,
          onClick: onClick,
          onVisible: onVisible,
          onClosing: onClosing),
    );
  }
}

class FloatingWidgetAlert extends OverlayRoute {
  /// Chamar um widget flutuante customizável de sobreposição[Overlay]
  /// sem em bloquear a rota(página) ativa
  ///
  final Widget widget;
  Offset? offset;
  final Duration? duration;
  final void Function()? onClick;
  final void Function()? onVisible;
  final void Function()? onClosing;

  FloatingWidgetAlert(
      {required this.widget,
      this.offset,
      this.duration,
      this.onClick,
      this.onVisible,
      this.onClosing})
      : super(settings: const RouteSettings(name: 'FloatingWidgetAlert'));

  @override
  void install() {
    super.install();

    onVisible?.call();

    if (duration != null) Future.delayed(duration!, dispose);
  }

  @override
  void dispose() {
    print('---- Disposing FloatingWidget ----');

    onClosing?.call();

    /*if(isCurrent){
      navigator?.pop();
    }else if(isActive){
      //navigator?.removeRoute(this); 
      navigator?.finalizeRoute(this);  
    }else{
      super.overlayEntries[0].remove();
      super.dispose();
    }*/

    super.overlayEntries[0].remove();
    super.dispose();
  }

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      OverlayEntry(builder: (_) {
        offset ??= Offset(MediaQuery.of(_).size.width - 110,
            MediaQuery.of(_).size.height - 98);
        //print(MediaQuery.of(_).size.width);
        //print(MediaQuery.of(_).size.height);
        return Positioned(
          left: offset!.dx,
          top: offset!.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              //offset += details.delta; //(gerando erro)
              offset = Offset(
                  offset!.dx + details.delta.dx, offset!.dy + details.delta.dy);
              //print('${offset!.dx}  ${offset!.dy}');
              //print('${details.globalPosition.dx}');

              if (super.overlayEntries.isNotEmpty)
                super.overlayEntries[0].markNeedsBuild(); // setState

              if (offset!.dx < 0 || offset!.dy < 0) dispose();
            },
            onLongPress: dispose,
            onTap: onClick,
            child: widget,
          ),
        );
      }),
    ];
  }
}
