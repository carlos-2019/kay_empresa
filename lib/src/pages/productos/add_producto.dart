import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kay_empresa/src/pages/homePage2.dart';

class CrearProducto2 extends StatefulWidget {
  @override
  _CrearProductoState2 createState() => _CrearProductoState2();
}

class _CrearProductoState2 extends State<CrearProducto2> {
  // input
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _cantidad1Controller = TextEditingController();
  TextEditingController _precio1Controller = TextEditingController();
  TextEditingController _cantidad2Controller = TextEditingController();
  TextEditingController _precio2Controller = TextEditingController();
  TextEditingController _cantidad3Controller = TextEditingController();
  TextEditingController _precio3Controller = TextEditingController();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();

  bool uploading = false;
  double val = 0;
  final formKey = GlobalKey<FormState>();
  FirebaseStorage ref = FirebaseStorage.instance;
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  List<File> _image = [];
  List<String> _url = [];

  String url; // url de la imagen

  // Input
  String nombre;
  //
  String cantidad1;
  double precio1;
  //
  String cantidad2;
  double precio2;
  //
  String cantidad3;
  double precio3;
  //
  int stock;
  String descripcion;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kay'),
      ),
      body: body(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await formularioProducto(context);
        },
        label: Text('Agregar'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget body() {
    return Container(
      child: GridView.builder(
        itemCount: _image.length + 1,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return index == 0
              ? Center(
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      chooseImage();
                    },
                  ),
                )
              : formularioFoto(index);
        },
      ),
    );
  }

  Future<void> formularioProducto(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                    ),
                    validator: (value) {
                      return value.isEmpty ? 'El nombre es requerido' : null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _cantidad1Controller,
                    decoration: InputDecoration(
                      labelText: 'Cantidad 1',
                    ),
                    validator: (value) {
                      return value.isEmpty ? 'La cantidad es requerido' : null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _precio1Controller,
                    decoration: InputDecoration(
                      labelText: 'Precio 1',
                    ),
                    validator: (value) {
                      return value.isEmpty ? 'El precio es requerido' : null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _cantidad2Controller,
                    decoration: InputDecoration(
                      labelText: 'Cantidad 2',
                    ),
                    validator: (value) {
                      return value.isEmpty ? 'La cantidad es requerido' : null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _precio2Controller,
                    decoration: InputDecoration(
                      labelText: 'Precio 2',
                    ),
                    validator: (value) {
                      return value.isEmpty ? 'El precio es requerido' : null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _cantidad3Controller,
                    decoration: InputDecoration(
                      labelText: 'Cantidad 3',
                    ),
                    validator: (value) {
                      return value.isEmpty ? 'La cantidad es requerido' : null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _precio3Controller,
                    decoration: InputDecoration(
                      labelText: 'Precio 3',
                    ),
                    validator: (value) {
                      return value.isEmpty ? 'El precio es requerido' : null;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _stockController,
                    decoration: InputDecoration(
                      labelText: 'Stock',
                    ),
                    validator: (value) {
                      return value.isEmpty ? 'El Stock es requerido' : null;
                    },
                  ),
                  TextFormField(
                    autofocus: true,
                    controller: _descripcionController,
                    decoration: InputDecoration(
                      labelText: 'Descripcion',
                    ),
                    validator: (value) {
                      return value.isEmpty
                          ? 'La Descripcion es requerido'
                          : null;
                    },
                  ),
                  ElevatedButton(
                    child: Text('Registrar'),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                      elevation: 10.0,
                    ),
                    onPressed: uploadStatusImage,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<List> uploadStatusImage() async {
    int i = 1;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      Reference productImageref = ref.ref().child('Product Images');
      var timeKey = DateTime.now();
      final UploadTask uploadTask =
          productImageref.child(timeKey.toString() + ".jpg").putFile(img);
      var imageUrl = await uploadTask.then((res) => res.ref.getDownloadURL());
      _url.add(imageUrl.toString());
      i++;
    }
    saveToDatabese(_url);
    Navigator.pop(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomePage2();
    }));
    return _url;
  }

  void saveToDatabese(List url) {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    CollectionReference products =
        FirebaseFirestore.instance.collection('products');

    var data = {
      "image": _url,
      "nombre": _nombreController.text,
      "cantidad1": _cantidad1Controller.text,
      "precio1": double.parse(_precio1Controller.text),
      "cantidad2": _cantidad2Controller.text,
      "precio2": double.parse(_precio2Controller.text),
      "cantidad3": _cantidad3Controller.text,
      "precio3": double.parse(_precio3Controller.text),
      "stock": int.parse(_stockController.text),
      "descripcion": _descripcionController.text,
      "date": date,
      "time": time,
    };

    products
        .add(data)
        .then((value) => print("Producto agregado"))
        .catchError((error) => print("Error: $error"));
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  Widget formularioFoto(int index) {
    return Container(
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(
            _image[index - 1],
          ),
        ),
      ),
    );
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrievelostData();
  }

  Future<void> retrievelostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }
}
