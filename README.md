## Package criada para facilitar o uso de widget flutuantes(Overlay) que nos permite customizar de acordo com as necessidades da app

</br>
</br>

- Exemplo de uso de uma widget semelhante a uma [SnackBar]
```dart
SnackbarAlert.show(
    context: context, 
    child: const SnackbarDemo(),
);
```

</br>
</br>

- Exemplo de uso de uma widget semelhante a uma [Toast]
```dart
Toast.show(
    context: context,
    message: 'my massage'
);
```

</br>
</br>

- Exemplo de uso de uma widget semelhante a uma [Drawer]
```dart
DrawerAlert.show(
    context: context,
    child: const DrawerDemo(),
);
```

</br>
</br>

- Exemplo de uso de uma widget semelhante a uma [FloatingButton]
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

