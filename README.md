## Package criada para facilitar o uso de widget flutuantes(Overlay) que nos permita customizar de acordo com as necessidades da app


 - Exemplo de uso um widget semelhante a uma SnackBar
```dart
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
```


- Exemplo de uso um widget semelhante a uma Toast
```dart
Toast.show(
    context: context,
    message: 'my massage'
);
```


- Exemplo de uso um widget semelhante a uma FloatingButton
```dart
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
```

