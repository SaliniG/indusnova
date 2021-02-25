import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import './listpage.dart';
import 'data/data.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: new MyLoginPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  var _response;

  @override
  void initState() {
    _response = "";
    super.initState();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  void clearText() {
    nameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: nameController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "User name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );
    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () {
          print(nameController.text);
          print('pressed');
          getData(nameController.text, passwordController.text);
          //showAlertDialog(context);
        },
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getData(var username, var password) async {
    print('pressed');
    String requestBody = '''<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
        <IndusMobileUserLogin1 xmlns="http://tempuri.org/">
            <UserName>$username</UserName>
            <UserPassword>$password</UserPassword>
        </IndusMobileUserLogin1>
    </soap:Body>
</soap:Envelope>''';

    http.Response response = await http.post(
        'http://103.252.117.204:90/Indusssp/service.asmx?op=IndusMobileUserLogin1',
        headers: {
          "Content-Type": "text/xml;charset=UTF-8",
          "Authorization": "Basic bWVzdHJlOnRvdHZz",
          "cache-control": "no-cache"
        },
        body: utf8.encode(requestBody),
        encoding: Encoding.getByName("UTF-8"));
    try {
      xml.XmlDocument parsedXml = xml.XmlDocument.parse(response.body);
      print(response.body);
      final decoded = json.decode(parsedXml.text);
      final model = Data.fromJson(decoded[0]);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListPage()),
      );
      setState(() {
        _response = model.depratment;
        print(_response);
      });
    } catch (e) {
      setState(() {
        _response = "Login Failed";
      });
    }
    return response;
  }
}
