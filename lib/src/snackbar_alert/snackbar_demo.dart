part of './snackbar_alert.dart';

/// Exemplo de uma `Snackbar`
class SnackbarDemo extends StatelessWidget {
  const SnackbarDemo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 48.0,
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Customizable SnackBar',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Builder(builder: (context) {
              return TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
