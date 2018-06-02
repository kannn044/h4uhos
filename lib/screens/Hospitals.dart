import 'dart:async';
import 'package:flutter/material.dart';

class Hospitals extends StatefulWidget {
  @override
  _HospitalsState createState() => new _HospitalsState();
}

class _HospitalsState extends State<Hospitals> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ลงทะเบียนหน่วยบริการ')),
      body: ListView(
        children: <Widget>[
          new ListTile(
//            leading: new Icon(Icons.settings),
            title: new Text(
              'โรงพยาบาลกันทรวิชัย',
              style: new TextStyle(fontSize: 25.0),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {

              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'เพิ่มสถานพยาบาล',
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/hospital/register');
        },
      ),
    );
  }
}
