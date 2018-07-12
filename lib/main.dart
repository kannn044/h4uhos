import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

import 'package:h4u/screens/LoginScreen.dart';
import 'package:h4u/screens/SplashScreen.dart';

void main() {
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
        primarySwatch: Colors.teal,
      ),
      title: 'Health for you',
      home: new SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => new LoginScreen(),
      },
    ),
  );
}
