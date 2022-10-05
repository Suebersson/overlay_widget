## Package criada para facilitar o uso de widget flutuantes(Overlay) que nos permita customizar de acordo com as necessidades da app


 - Exemplo de uso um widget semelhante a uma SnackBar
```dart
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
```


- Exemplo de uso um widget semelhante uma Toast
```dart
Toast.show(
    context: context,
    message: 'my massage'
);
```


- Exemplo de uso um widget semelhante uma FloatingButton
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

