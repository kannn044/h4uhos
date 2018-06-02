import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

TextEditingController _username;
TextEditingController _password;
String _sex = 'ชาย';
String _birthdate;

class _RegisterPageState extends State<RegisterPage> {

  @override
  Widget build(BuildContext context) {

    DateTime _currentDate = new DateTime.now();

    Future<Null> _selectBirthdate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          locale: const Locale('th'),
          context: context,
          initialDate: DateTime(1920, 1, 1),
          firstDate: new DateTime(1920, 1, 1), lastDate: new DateTime(2018));
      if (picked != null && picked != _currentDate) {
        setState(() {
          var formatter = new DateFormat('yyyy-MM-dd');
          String formatted = formatter.format(picked);
          _birthdate = formatted;
        });
      }
    }

    ListView _form = ListView(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.all(20.0),
          child: const Text(
            "ลงทะเบียนเพื่อขอใช้บริการ",
            style: TextStyle(fontSize: 30.0),
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: new TextFormField(
            maxLength: 13,
            style: TextStyle(fontSize: 20.0, color: Colors.black, fontFamily: "ThaiSansNeue"),
            decoration: new InputDecoration(
                labelText: 'เลขบัตรประชาชน',
                labelStyle: TextStyle(fontSize: 25.0),
//              icon: Icon(Icons.email),
                helperText: 'ระบุเลขบัตรประชาชนสำหรับเปิดใช้บริการ HDC',
                filled: false),
            keyboardType: TextInputType.emailAddress,
            controller: _username,
          ),
        ),

        new Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: new ListTile(
            title: const Text('เพศ', style: TextStyle(fontSize: 25.0),),
            trailing: new DropdownButton<String>(
              value: _sex,
              style: TextStyle(fontSize: 25.0, fontFamily: "ThaiSansNeue", color: Colors.black),
              onChanged: (String newValue) {
                // ignore: implicit_this_reference_in_initializer
                setState(() {
                  _sex = newValue;
                });
              },
              items: <String>['ชาย', 'หญิง'].map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
            ),
          ),
        ),

        new Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          child: new ListTile(
              onTap: () {
                _selectBirthdate(context);
              },
              title: const Text('วันเกิด', style: TextStyle(fontSize: 25.0),),
              trailing: Text(_birthdate != null ? _birthdate : 'เลือกวันเกิด', style: TextStyle(fontSize: 25.0, fontFamily: "ThaiSansNeue", color: Colors.black))
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: new TextFormField(
            decoration: new InputDecoration(
                labelText: 'อีเมล์',
                labelStyle: TextStyle(fontSize: 25.0),
//              icon: Icon(Icons.email),
                helperText: 'ระบุอีเมล์ผู้ใช้งาน',
                filled: false),
            keyboardType: TextInputType.emailAddress,
            controller: _username,
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: new TextFormField(
            decoration: new InputDecoration(
                labelText: 'ชื่อ',
                labelStyle: TextStyle(fontSize: 25.0),
//              icon: Icon(Icons.email),
                helperText: 'ชื่อจริง',
                filled: false),
            keyboardType: TextInputType.emailAddress,
            controller: _username,
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: new TextFormField(
            decoration: new InputDecoration(
                labelText: 'นามสกุล',
                labelStyle: TextStyle(fontSize: 25.0),
//              icon: Icon(Icons.email),
                helperText: 'นามสกุล',
                filled: false),
            keyboardType: TextInputType.emailAddress,
            controller: _username,
          ),
        ),
        Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
          child: new TextFormField(
            decoration: new InputDecoration(
                labelText: 'รหัสผ่าน',
                labelStyle: TextStyle(fontSize: 25.0),
//              icon: Icon(Icons.vpn_key),
                helperText: 'รหัสผ่านสำหรับเข้าใช้งานอย่างน้อย 8 ตัวอักษร',
                counterText: ''),
            obscureText: true,
            controller: _password,
          ),
        ),

      ],
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('ลงทะเบียนขอใช้บริการ'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.save),
              onPressed: () {

              },
            ),
          ],
        ),
        body: _form

    );
  }

  void _saveRegister() {}
}
