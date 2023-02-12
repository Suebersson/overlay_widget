
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
                SnackbarAlert.show(
                  context: context, 
                  child: const SnackbarDemo(),
                );
              },
            ),
            GenericButton(
              name: 'ToastShow',
              onTap: () {
                ToastAlert.show(
                  context: context,
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
                FloatingWidgetAlert.show(
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
