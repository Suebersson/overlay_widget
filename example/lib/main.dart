
import 'package:flutter/material.dart';
import 'package:overlay_widget/overlay_widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App",
      theme: ThemeData(primaryColor: Colors.indigo),
      home: const MyCustomizedOverlay(),    
    );
  }
}

class MyCustomizedOverlay extends StatelessWidget {
  const MyCustomizedOverlay({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Overlay customizados")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GenericButton(
              name: 'SnackBarShow',
              onTap: () {
                SnackBarShow.show(
                  context: context,
                  snackBarAlignment: SnackBarAlignment.bottom,
                  widget: Material(
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
                          TextButton(
                            onPressed: () => print('SnackBar demo'), 
                            child: const Text(
                              'Ok',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            GenericButton(
              name: 'ToastShow',
              onTap: () {
                Toast.show(
                  context: context,
                  toastAlignment: ToastAlignment.bottom,
                  child: const Text(
                    'my massage',
                    softWrap:  true,
                    style: TextStyle(fontSize: 17.0, color: Colors.white),
                  ),
                );
              },
            ),
            GenericButton(
              name: 'FloatingWidget',
              onTap: () {
                FloatingWidget.show(
                  context: context,
                  widget: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue[300],
                    ),
                    child: const Icon(Icons.adb, color: Colors.white, size: 35),
                  )
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GenericButton extends StatelessWidget {
  const GenericButton({Key? key, required this.onTap, required this.name}) : super(key: key);
  
  final void Function() onTap;
  final String name;

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          color: Theme.of(context).primaryColor,
          margin: const EdgeInsets.only(top: 40),
          height: 50,
          width: 300,
          child: Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      );
  }
}
