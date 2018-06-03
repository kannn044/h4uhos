
import 'package:flutter/material.dart';

class AddActivities extends StatefulWidget {
  @override
  _AddActivitiesState createState() => new _AddActivitiesState();
}

class _AddActivitiesState extends State<AddActivities> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('บันทึกข้อมูลสุขภาพ'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        children: <Widget>[

        ],
      ),
    );
  }
}
