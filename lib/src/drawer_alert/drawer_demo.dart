part of './drawer_alert.dart';

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
              child: Text(
                'Drawer demo',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const Divider(color: Colors.white, height: 3.5),
            Expanded(
              child: Container(
                color: Colors.blueGrey[400],
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.all(5.0),
                alignment: Alignment.center,
                child: const Text(
                  'seus widgets',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
