import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

import 'package:h4u/screens/LoginScreen.dart';
import 'package:h4u/screens/SplashScreen.dart';
import 'package:h4u/screens/Hospitals.dart';
import 'package:h4u/screens/RegisterScreen.dart';
import 'package:h4u/screens/InfoScreen.dart';
import 'package:h4u/screens/HospitalRegister.dart';
import 'package:h4u/screens/AddActivities.dart';

void main() async {
  runApp(
    new MaterialApp(
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('th', 'TH'),
      ],
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
        '/activities/add': (BuildContext context) => new AddActivities(),
      },
    ),
  );
}
