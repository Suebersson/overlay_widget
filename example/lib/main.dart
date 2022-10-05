
import 'package:flutter/material.dart';
import 'package:overlay_widget/src/snackBarAlert.dart';
import 'package:overlay_widget/src/toastAlert.dart';
import 'package:overlay_widget/src/floatingWidget.dart';

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
                  duration: 6000,
                  height: 48.0,
                  snackBarAlignment: SnackBarAlignment.bottomLeftToRigth,
                  widget: Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Customizable SnackBar',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () => print('SnackBar demo'),
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              width: 60.0,
                              child: const Text(
                                'Ok',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          )
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
                  message: 'my massage'
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
