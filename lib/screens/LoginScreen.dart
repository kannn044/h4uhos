import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:h4u/screens/HomeScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: <String>[
      'profile',
      'email',
    ],
  );

  GoogleSignInAccount _googleUser;
  FirebaseUser _firebaseUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  verifyGoogle() async {
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      FirebaseUser user = await _auth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    });

    _googleSignIn.signInSilently();
  }

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

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _googleSignIn.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> _handleSignIn() async {
      try {
//      await _googleSignIn.signIn();
        GoogleSignInAccount googleUser = await _googleSignIn.signIn();
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        _showLoading();

        FirebaseUser user = await _auth.signInWithGoogle(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        if (user != null) {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => new HomeScreen(user)),
          );
        }
      } catch (error) {
        print(error);
      }
    }

    void _loginWithEmailPassword() async {
      if (_email != null && _password != null) {
        try {

          _showLoading();

          FirebaseUser user = await _auth.signInWithEmailAndPassword(
              email: _email, password: _password);
          if (user != null) {
            print(user);
            String uid = user.uid.toString();
            var url =
                "http://203.157.102.103/api/phr/v1/user/profiles?uid=$uid";
            http.get(url).then((response) {
              print(response.body);
              if (response.statusCode == 200) {
                var jsonResponse = json.decode(response.body);
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new HomeScreen(user)),
                );
              }
            });
          } else {
            print('login failed');
          }
        } catch (error) {
          print('login failed');
        }
      } else {
        print('login failed');
      }
    }

    Widget _loginPage = new ListView(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 50.0,
                  child: Icon(Icons.notifications_active,
                      color: Colors.white, size: 50.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                Text(
                  "สมุดสุขภาพประจำตัวประชาชน",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//            new Padding(
//              padding: const EdgeInsets.all(20.0),
//              child: const Text(
//                "เข้าสู่ระบบเพื่อใช้งานโปรแกรม",
//                style: TextStyle(fontSize: 30.0),
//              ),
//            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
              child: new TextField(
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontFamily: 'ThaiSansNeue'),
                decoration: new InputDecoration(
                    labelStyle: TextStyle(fontSize: 20.0),
                    labelText: 'อีเมล์',
                    icon: Icon(Icons.email),
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
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
              child: new TextField(
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontFamily: 'ThaiSansNeue'),
                decoration: new InputDecoration(
                  labelText: 'รหัสผ่าน',
                  labelStyle: TextStyle(fontSize: 20.0),
                  icon: Icon(Icons.vpn_key),
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
                  borderRadius: BorderRadius.all(const Radius.circular(30.0)),
                  shadowColor: Colors.redAccent.shade100,
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 300.0,
                    height: 60.0,
                    onPressed: () {
                      _loginWithEmailPassword();
                    },
                    color: Colors.red,
                    child: Text(
                      'ล๊อกอินเข้าใช้งาน',
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
            Column(
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.all(const Radius.circular(30.0)),
                  shadowColor: Colors.lightBlueAccent.shade100,
                  elevation: 5.0,
                  child: MaterialButton(
                    minWidth: 300.0,
                    height: 60.0,
                    onPressed: () {
                      _handleSignIn()
                          .then((FirebaseUser user) => {})
                          .catchError((e) => print(e));
                    },
                    color: Colors.blue,
                    child: new Text(
                      "ล๊อกอินด้วย Google",
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: FlatButton(
                child: Text(
                  'ลงทะเบียนขอใช้บริการ',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.3,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                },
              ),
            )
          ],
        ),
      ],
    );

    return Scaffold(
      key: _scaffoldKey,
      body: _loginPage,
    );
  }
}
