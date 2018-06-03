import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class AddActivities extends StatefulWidget {
  @override
  _AddActivitiesState createState() => new _AddActivitiesState();
}

class _AddActivitiesState extends State<AddActivities> {

  double _bpD = 80.0;
  double _bpS = 120.0;
  double _fbs = 100.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final slider = new Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text(
            'ความดันโลหิตบน (มม. ปรอท)',
            style: TextStyle(fontSize: 20.0),
          ),
          new ListTile(
            trailing: Text(
              '${_bpS.round()}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            ),
            title: Slider(
              min: 20.0,
              max: 500.0,
              value: _bpS,
              label: 'ความดันโลหิต',
              onChanged: (double value) {
                setState(() {
                  _bpS = value;
                });
              },
            ),
          ),
//          Divider(),
          new Text(
            'ความดันโลหิตล่าง (มม. ปรอท)',
            style: TextStyle(fontSize: 20.0),
          ),
          new ListTile(
            trailing: Text(
              '${_bpD.round()}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            ),
            title: Slider(
              min: 20.0,
              max: 500.0,
              value: _bpD,
              label: 'ความดันโลหิต',
              onChanged: (double value) {
                setState(() {
                  _bpD = value;
                });
              },
            ),
          ),
          new Text(
            'ระดับน้ำตาลในเลือก (มก./ดล.)',
            style: TextStyle(fontSize: 20.0),
          ),
          new ListTile(
            trailing: Text(
              '${_fbs.round()}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            ),
            title: Slider(
              min: 20.0,
              max: 500.0,
              value: _fbs,
              label: 'ความดันโลหิต',
              onChanged: (double value) {
                setState(() {
                  _fbs = value;
                });
              },
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'อัตราเต้นของหัวใจ',
                      hintText: '90',
                      helperText: '(ครั้ง/นาที)',
                      labelStyle: TextStyle(fontSize: 20.0),
                    ),
                    maxLength: 3,
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.important_devices,
                      size: 40.0,
                      color: Colors.green,
                    ),
                    tooltip: 'อ่านจากอุปกรณ์',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          new Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'นำ้หนัก',
                      helperText: 'กก.',
                      labelStyle: TextStyle(fontSize: 20.0),
                    ),
                    maxLength: 3,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                new Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'ส่วนสูง',
                        helperText: 'ซม.',
                        labelStyle: TextStyle(fontSize: 20.0)),
                    maxLength: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('บันทึกข้อมูลสุขภาพ'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            tooltip: 'บันทึก',
            onPressed: () {  },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          slider,
        ],
      ),
    );
  }
}
