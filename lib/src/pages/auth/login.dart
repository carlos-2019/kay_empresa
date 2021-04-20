import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kay_empresa/src/pages/homePage2.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailtextEditingController =
      TextEditingController();
  final TextEditingController _passwordtextEditingController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 80.0),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    'assets/images/login.png',
                    height: 240.0,
                    width: 240.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Bienvenido a Kay',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 25.0,
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      autofocus: true,
                      controller: _emailtextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Correo Electronico',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _passwordtextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      child: Text('Iniciar Sesion'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        shadowColor: Colors.grey,
                        primary: Colors.redAccent,
                        onPrimary: Colors.white,
                        elevation: 10.0,
                      ),
                      onPressed: () {
                        _emailtextEditingController.text.isNotEmpty &&
                                _passwordtextEditingController.text.isNotEmpty
                            ? loginUser()
                            : showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: Text(
                                        'Debe llenar el correo y contraseña'),
                                  );
                                },
                              );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginUser() async {
    await _auth
        .signInWithEmailAndPassword(
            email: _emailtextEditingController.text.trim(),
            password: _passwordtextEditingController.text.trim())
        .then((value) =>
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return HomePage2();
            })))
        .catchError((error) {});
  }
}
