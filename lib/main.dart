import 'dart:async';
import 'dart:convert' show json;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:h4u/screens/Services.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:h4u/screens/LoginScreen.dart';
import 'package:h4u/screens/SplashScreen.dart';
import 'package:h4u/screens/Hospitals.dart';
import 'package:h4u/screens/RegisterScreen.dart';
import 'package:h4u/screens/InfoScreen.dart';
import 'package:h4u/screens/HospitalRegister.dart';

void main() {
  runApp(
    new MaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
        supportedLocales: [
        const Locale('th', 'TH'),],
    theme: ThemeData(
        fontFamily: 'ThaiSansNeue',
        primarySwatch: Colors.pink,
      ),
      title: 'Health for you',
      home: new SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/register': (BuildContext context) => new RegisterPage(),
        '/login': (BuildContext context) => new LoginScreen(),
        '/info': (BuildContext context) => new InfoScreen(),
        '/hospital': (BuildContext context) => new Hospitals(),
        '/hospital/register': (BuildContext context) => new HospitalRegister(),
      },
    ),

  );
}

//
//
//class SmartPhr extends StatefulWidget {
//  @override
//  State createState() => new SmartPhrState();
//}
//
//class SmartPhrState extends State<SmartPhr> {
//
//  String _currentUser;
//
////  Future<Null> _handleSignOut() async {
////    _googleSignIn.disconnect();
////    setState(() {
////      _currentPage = "LOGINPAGE";
////    });
////  }
//
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
////    startTime();
//  }
//
////  startTime() async {
////    var _duration = new Duration(seconds: 2);
////    return new Timer(_duration, navigationPage);
////  }
//
//  void navigationPage() {
//    Navigator.of(context).pushReplacementNamed('/login');
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}
