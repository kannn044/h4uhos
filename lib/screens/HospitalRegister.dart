import 'dart:async';
import 'package:flutter/material.dart';

class HospitalRegister extends StatefulWidget {
  @override
  _HospitalRegisterState createState() => new _HospitalRegisterState();
}

class _HospitalRegisterState extends State<HospitalRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มสถานพยาบาล'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {

            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[

        ],
      ),
    );
  }
}
