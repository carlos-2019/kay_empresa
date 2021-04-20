import 'package:flutter/material.dart';
import 'package:kay_empresa/src/pages/products/crear_producto.dart';

class ListProduct extends StatefulWidget {
  @override
  _ListProductState createState() => _ListProductState();
}

class _ListProductState extends State<ListProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('a'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CrearProducto();
          }));
        },
        label: Text('Agregar Producto'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}
