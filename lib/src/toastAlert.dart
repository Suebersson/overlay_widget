import 'package:flutter/material.dart';

/// Chamar um widget customizavel de sobreposição(overlay) semelhante a uma Toast nativa do android.
/// O Widget [ToastAlert] pode ser chamado diretamente pela classe ou pelo método [Toast.show]
abstract class Toast {
  /// Exemplo de uso: Toast.show(context: context, message: 'My toast');
  static void show(
      {required BuildContext context,
      required String message,
      TextStyle textStyle =
          const TextStyle(fontSize: 17.0, color: Colors.white),
      Color backgroundColor = Colors.black54,
      Duration duration = const Duration(milliseconds: 3500),
      ToastAlignment toastAlignment = ToastAlignment.center,
      BorderRadiusGeometry? borderRadius}) {
    Navigator.push(
      context,
      ToastAlert(
          message: message,
          backgroundColor: backgroundColor,
          textStyle: textStyle,
          duration: duration,
          toastAlignment: toastAlignment,
          borderRadius: borderRadius),
    );
  }
}

class ToastAlert extends OverlayRoute {
  /// Navegar para um [widget] semelhante a uma Toast do tipo [overlay]
  /// sem bloquear a rota(página) ativa
  final String message;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Duration duration;
  final ToastAlignment toastAlignment;
  final BorderRadiusGeometry? borderRadius;

  ToastAlert(
      {required this.message,
      this.textStyle = const TextStyle(fontSize: 17.0, color: Colors.white),
      this.backgroundColor = Colors.black54,
      this.duration = const Duration(milliseconds: 3500),
      this.toastAlignment = ToastAlignment.center,
      this.borderRadius})
      : super(settings: const RouteSettings(name: 'ToastAlert'));

  late AnimationController _animationController;

  void _close() {
    /*Future.delayed(
      duration,
      (){
        if(isCurrent){
          navigator?.pop();
        }else if(isActive){
          //navigator?.removeRoute(this); 
          navigator?.finalizeRoute(this);  
        }else{
          dispose();
        }
      }
    );*/
    Future.delayed(duration, dispose);
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

    Future.delayed(duration, () {
      _animationController.reverse();
      _close();
    });
  }

  @override
  TickerFuture didPush() {
    super.didPush();
    return _animationController.forward();
  }

  @override
  void dispose() {
    print('---- Disposing Toast ----');

    _animationController.dispose();
    super.overlayEntries[0].remove();
    super.dispose();
  }

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
                  padding: const EdgeInsets.symmetric(
                      vertical: 65.0, horizontal: 15.0),
                  child: Center(
                    child: Material(
                      color: backgroundColor,
                      borderRadius: borderRadius ?? BorderRadius.circular(30.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 7.0),
                        child: Text(
                          message,
                          softWrap: true,
                          style: textStyle,
                        ),
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

/// Definir o aliamento da [ToastAlert]
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
