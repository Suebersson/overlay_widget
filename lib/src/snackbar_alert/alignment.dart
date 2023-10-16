part of './snackbar_alert.dart';

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
