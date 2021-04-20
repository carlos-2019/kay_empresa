import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kay_empresa/src/pages/product.dart';
import 'package:kay_empresa/src/pages/productos/add_producto.dart';

class HomePage2 extends StatefulWidget {
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  List<String> imgList = [];
  String productId;
  List<Product> productList = [];
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Productos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: products.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return new ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return new Container(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5.0),
                        child:
                            Image.network(document.data()['image'].toString()),
                        width: 100,
                        height: 100,
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            document.data()['nombre'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 21.0,
                            ),
                          ),
                          subtitle: Text(
                            document.data()['descripcion'].toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 21.0,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          deleteProduct(document.id);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          detalleProduct(document.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CrearProducto2();
          }));
        },
        label: Text('Agregar'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  detalleProduct(String id) {
    Size size = MediaQuery.of(context).size;
    return products
      ..doc(id).get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  content: Container(
                    height: size.height * 0.50,
                    child: Column(
                      children: <Widget>[
                        Text(
                          '${documentSnapshot.data()['date']}',
                        ),
                        Text(
                          '${documentSnapshot.data()['time']}',
                        ),
                        Text(
                          '${documentSnapshot.data()['nombre']}',
                        ),
                        Text(
                          '${documentSnapshot.data()['cantidad1']}',
                        ),
                        Text(
                          '${documentSnapshot.data()['precio1']}',
                        ),
                        Text(
                          '${documentSnapshot.data()['cantidad2']}',
                        ),
                        Text(
                          '${documentSnapshot.data()['precio2']}',
                        ),
                        Text(
                          '${documentSnapshot.data()['cantidad3']}',
                        ),
                        Text(
                          '${documentSnapshot.data()['precio3']}',
                        ),
                        Text(
                          '${documentSnapshot.data()['stock']}',
                        ),
                        Text(
                          '${documentSnapshot.data()['descripcion']}',
                        ),
                      ],
                    ),
                  ),
                );
              });
        } else {
          print('Document does not exist on the database');
        }
      });
  }

  deleteProduct(String id) {
    return products
        .doc(id)
        .delete()
        .then((value) => print("Eliminado Correctamente"))
        .catchError((error) => print("Error al eliminar: $error"));
  }
}
