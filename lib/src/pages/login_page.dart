import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  Map<String, String> _dataLogin = {
    'identifier': '',
    'password': '',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context)
        ],
      )
    );
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration:  BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(103, 181, 30, 1.0),
            Color.fromRGBO(103, 181, 30, 0.8),
          ]
        )
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius:  BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.3)
      ),
    );

    return Stack(children: <Widget>[
      fondoMorado,
      Positioned(child: circulo, top: 90.0, left: 30.0),
      Positioned(child: circulo, top: -40.0, right: -30.0),
      Positioned(child: circulo, bottom: -50.0, right: -10.0),
      Positioned(child: circulo, bottom: 120.0, right: 20.0),
      Positioned(child: circulo, bottom: -50.0, left: -20.0),
      
      Container(
        child: Column(
          
          children: <Widget>[
            Icon(Icons.delivery_dining, color: Colors.white, size: 100.0,),
            SizedBox(height: 10.0, width: double.infinity,),
            Text('SOAL NATURA ENTREGAS'.toUpperCase(), style: TextStyle(color: Colors.white),)
          ],
          
        ),
        padding: EdgeInsets.only(top: 80.0),
      )
      
    ]);
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: size.height * 0.3,
            ),
          ),
          Container(
            width: size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color:  Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('INGRESO'),
                SizedBox(height: 60.0),
                _crearUsuario(),
                SizedBox(height: 30.0),
                _crearPassword(),
                SizedBox(height: 30.0),
                _crearButton(context),
              ],
            ),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
          )
        ],
      ),
    );
  }

  Widget _crearUsuario() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        keyboardType: TextInputType.text,
        // decoration: InputDecoration(
        //   icon: Icon(Icons.account_circle, color: Color.fromRGBO(103, 181, 30, 1.0), size: 32.0,),
        //   hintText:'Nombre Apellido',
        //   labelText: 
        // ),
        decoration: InputDecoration(
          icon: Icon(Icons.account_circle, color: Color.fromRGBO(103, 181, 30, 1.0), size: 32.0,),                 
          labelText: 'NOMBRE DE USUARIO',
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(103, 181, 30, 1.0)
            ),                      
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(103, 181, 30, 1.0)
            ),                      
          ),
          labelStyle: TextStyle(color:  Color.fromRGBO(103, 181, 30, 1.0))                
        ),
        style: TextStyle(color:  Color.fromRGBO(103, 181, 30, 1.0)),
        cursorColor: Color.fromRGBO(103, 181, 30, 1.0),
        onChanged: (value) {
           setState(() {
            _dataLogin['identifier'] = value;
          });
        },
      ),
    );
  }

  Widget _crearPassword() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        obscureText: true,
        // decoration: InputDecoration(
        //   icon: Icon(Icons.lock_outline, color: Color.fromRGBO(103, 181, 30, 1.0), size: 32.0,),
        //   labelText: 'CONTRASEÑA'
        // ),
        decoration: InputDecoration(
          icon: Icon(Icons.lock_outline, color: Color.fromRGBO(103, 181, 30, 1.0), size: 32.0,),                 
          labelText: 'CONTRASEÑA',
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(103, 181, 30, 1.0)
            ),                      
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(103, 181, 30, 1.0)
            ),                      
          ),
          labelStyle: TextStyle(color:  Color.fromRGBO(103, 181, 30, 1.0))                
        ),
        style: TextStyle(color:  Color.fromRGBO(103, 181, 30, 1.0)),
        cursorColor: Color.fromRGBO(103, 181, 30, 1.0),
        onChanged: (value) {
          setState(() {
            _dataLogin['password'] = value;
          });
        },
      ),
    );
  }
   
  Widget _crearButton(BuildContext context) {
    return ElevatedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text('INGRESAR'),
        
      ),
      style: ElevatedButton.styleFrom(   
        primary: Color.fromRGBO(103, 181, 30, 1.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0) ),
      ),
      onPressed: () async {
        try {
          SharedPreferences perfs = await SharedPreferences.getInstance();
          final url = 'https://cosbiome.online/auth/local';
          final dataF = await http.post(url, body: _dataLogin);
          Map<dynamic, dynamic> datares = jsonDecode(dataF.body);

          String token  = datares['jwt'];
          String usuario = datares['user']['username'];
          bool telefono = datares['user']['telefono'];
          bool fechas = datares['user']['fechas'];

          perfs.setString('token', token);
          perfs.setString('usuario', usuario);
          perfs.setBool('telefono', telefono);
          perfs.setBool('fechas', fechas);

          Navigator.pushNamed(context, 'listapedidos');  
        } catch (e) {          
          print(e);
          _showMyDialog();
        }
        
      },
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error al inicar sesion'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Nombre de usuario o Contraseña incorrectos'),                
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}