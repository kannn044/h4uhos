import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:h4u/screens/HomeScreenHos.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _password;

  final TextEditingController _ctrlEmail = new TextEditingController();
  final TextEditingController _ctrlPassword = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showLoading() {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
//      duration: new Duration(seconds: 4),
      content: new Row(
        children: <Widget>[
          new CircularProgressIndicator(),
          new Text("  ล๊อกอินเข้าสู่โปรแกรม...")
        ],
      ),
    ));
  }

  void _showError(String message) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: new Duration(seconds: 4),
      content: new Row(
        children: <Widget>[new Text(message)],
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    void _loginWithEmailPassword() async {
      if (_email != null && _password != null) {
        try {
          var url = "http://203.157.102.103:443/api/phr/v1/hospital/login";
          var params = {"username": _email ?? '', "password": _password ?? ''};

          var response = await http.post(url, body: params);

          if (response.statusCode == 200) {
            var jsonResponse = json.decode(response.body);
            if (jsonResponse["ok"]) {
              Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                          new HomeScreenHos(jsonResponse["hcode"], _email)));
            } else {
              _showError("Email หรือ Password ไม่ถูกต้อง!");
            }
          } else {
            print('error');
          }
        } catch (error) {
          print(error.toString());
        }
      } else {
        _showError('ข้อมูลไม่ครบ');
      }
    }

    return Scaffold(
        key: _scaffoldKey,
        body: Stack(fit: StackFit.expand, children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.teal),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/logo_small.png'),
                        width: 100.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'ลงชื่อเข้าใช้งาน',
                        style: TextStyle(
                            fontSize: 26.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'สำหรับโรงพยาบาล',
                        style: TextStyle(fontSize: 22.0, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 30.0),
                        child: new TextField(
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontFamily: 'ThaiSansNeue'),
                          decoration: new InputDecoration(
                              fillColor: Colors.white,
                              labelStyle: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                              labelText: 'อีเมล์',
                              icon: Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
//                helperText: 'ระบุอีเมล์ผู้ใช้งาน',
                              filled: false),
                          keyboardType: TextInputType.emailAddress,
                          controller: _ctrlEmail,
                          onChanged: (String value) {
                            _email = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 30.0),
                        child: new TextField(
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontFamily: 'ThaiSansNeue'),
                          decoration: new InputDecoration(
                            labelText: 'รหัสผ่าน',
                            labelStyle:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                            icon: Icon(
                              Icons.vpn_key,
                              color: Colors.white,
                            ),
//                  helperText: 'รหัสผ่าน'
                          ),
                          obscureText: true,
                          controller: _ctrlPassword,
                          onChanged: (String value) {
                            _password = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Column(
                        children: <Widget>[
                          Material(
                            borderRadius:
                                BorderRadius.all(const Radius.circular(30.0)),
                            shadowColor: Colors.redAccent.shade100,
                            elevation: 5.0,
                            child: MaterialButton(
                              minWidth: 250.0,
                              height: 55.0,
                              onPressed: () {
                                _loginWithEmailPassword();
                              },
                              color: Colors.greenAccent,
                              child: Text(
                                'เข้าสู่ระบบ',
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      Text(
                        "สมุดสุขภาพประชาชน",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "ศูนย์เทคโนโลยีสารสนเทศและการสื่อสาร",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                      Text(
                        "สำนักงานปลัดกระทรวงสาธารณสุข กระทรวงสาธารณสุข",
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      )
                    ],
                  ))
            ],
          )
        ]));
  }
}
