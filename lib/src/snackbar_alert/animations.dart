part of './snackbar_alert.dart';

@immutable
class _SelectedSnackbarAnimation extends StatelessWidget {
  const _SelectedSnackbarAnimation({
    Key? key,
    required this.snackbarAlert,
    required this.child,
  }) : super(key: key);

  final SnackbarAlert snackbarAlert;
  final Widget child;

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
