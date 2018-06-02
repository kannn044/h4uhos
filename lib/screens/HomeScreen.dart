import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:h4u/screens/Services.dart';
import 'package:h4u/widgets/Dashboard.dart';

class HomeScreen extends StatefulWidget {
  FirebaseUser _firebaseUser;

  HomeScreen(this._firebaseUser);

  @override
  _HomeScreenState createState() => new _HomeScreenState(this._firebaseUser);
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseUser _firebaseUser;
  Map _userInfo;

  PageController _pageController;
  String barcode = "";
  int _page = 0;

  _HomeScreenState(this._firebaseUser);

  void _getUserInfo() async {
    String uid = this._firebaseUser.uid.toString();
    var url = "http://203.157.102.103/api/phr/v1/user/profiles?uid=$uid";
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse["ok"]) {
        print(jsonResponse["rows"][0]);
        if (jsonResponse["rows"][0] != null) {
          setState(() {
            _userInfo = jsonResponse["rows"][0];
            print(_userInfo);
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _getUserInfo();

    _pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _service = Scaffold(
      body: ListView(
        children: <Widget>[
          new ListTile(
//            leading: new Icon(Icons.person),
            title: new Text(
              'ประวัติรับบริการที่สถานพยาบาล',
              style: new TextStyle(fontSize: 25.0),
            ),
            subtitle: Text('ดูประวัติการรับบริการที่สถานพยาบาลต่าง'),
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new Services(_firebaseUser.uid)),
              );
            },
          ),
          new ListTile(
//            leading: new Icon(Icons.settings),
            title: new Text(
              'ระบบคิวออนไลน์',
              style: new TextStyle(fontSize: 25.0),
            ),
            trailing: new Icon(Icons.brightness_1,
                size: 8.0, color: Colors.redAccent),
            subtitle: Text('ตรวจสอบคิว/จองคิวล่วงหน้า'),
            onTap: () {
              // Update the state of the app
              // ...
            },
          ),
        ],
      ),
    );

    var _isAlert = false;

    void showMenuSelection(String value) {
      print(value);
      if (value == 'SIGNOUT') {
        Navigator.of(context).pushReplacementNamed('/login');
      }

      if (value == 'EDIT_PERSON') {
        Navigator.of(context).pushNamed('/info');
      }
    }

    void mainMenuSelection(String value) {
      print(value);
      if (value == 'SIGNOUT') {
        Navigator.of(context).pushReplacementNamed('/login');
      }

      if (value == 'ADD_ACTIVITIES') {
        Navigator.of(context).pushNamed('/activities/add');
      }
    }

    Widget _settings;
    _settings = new ListView(
      children: <Widget>[
        ListTile(
          leading: _firebaseUser.photoUrl != null
              ? new CircleAvatar(
                  backgroundImage: NetworkImage(_firebaseUser.photoUrl),
                )
              : _userInfo != null
                  ? CircleAvatar(
                      backgroundColor: Colors.brown.shade800,
                      child: new Text(
                          '${_userInfo["first_name"][0].toUpperCase()}${_userInfo["last_name"][0].toUpperCase()}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),))
                  : CircleAvatar(
                      backgroundColor: Colors.brown.shade800,
                      child: new Text('UK')),
          title: new Text(
            _firebaseUser.displayName != null
                ? _firebaseUser.displayName
                : _userInfo != null
                    ? '${_userInfo["first_name"]}  ${_userInfo["last_name"]}'
                    : "UNKNOW USER",
            style: TextStyle(fontSize: 25.0),
          ),
          subtitle: new Text(
              _firebaseUser.email != null
                  ? _firebaseUser.email
                  : "UNKNOW EMAIL",
              style: TextStyle(fontSize: 18.0)),
          trailing: new PopupMenuButton<String>(
            onSelected: showMenuSelection,
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                  const PopupMenuItem<String>(
                      value: 'EDIT_PERSON',
                      child: const Text(
                        'แก้ไขข้อมูลส่วนตัว',
                        style: TextStyle(fontSize: 20.0),
                      )),
                  const PopupMenuItem<String>(
                      value: 'CHANGE_PASSWORD',
                      child: const Text('เปลี่ยนรหัสผ่าน',
                          style: TextStyle(fontSize: 20.0))),
                  const PopupMenuItem<String>(
                      value: 'SIGNOUT',
                      child: const Text('ออกจากโปรแกรม',
                          style: TextStyle(fontSize: 20.0))),
                ],
          ),
        ),
        SwitchListTile(
          value: _isAlert,
          onChanged: (bool value) {
            setState(() {
              _isAlert = value;
            });
          },
          title: new Text(
            "รับการแจ้งเตือนจากระบบ",
            style: TextStyle(fontSize: 23.0),
          ),
          subtitle: new Text("แจ้งเตือนเมื่อมีข่าวสาร หรือ ข้อมูลจากโรงพยาบาล"),
        ),
        ListTile(
          title: new Text(
            "ยกเลิกการใช้บริการ",
            style: TextStyle(fontSize: 23.0),
          ),
          subtitle: new Text("ยกเลิกการใช้งานแอพลิเคชั่นนี้",
              style: TextStyle(fontSize: 18.0)),
        ),
        ListTile(
          title: new Text(
            "สถานพยาบาลที่ลงทะเบียน",
            style: TextStyle(fontSize: 23.0),
          ),
          subtitle: new Text("เพิ่ม/ลบ สถานพยาบาลที่ให้บริการ",
              style: TextStyle(fontSize: 18.0)),
          onTap: () {
            Navigator.of(context).pushNamed('/hospital');
          },
        ),
        Divider(),
        ListTile(
          title: new Text(
            "สำรองข้อมูลบนคลาวด์",
            style: TextStyle(fontSize: 23.0),
          ),
          subtitle: new Text("ล่าสุดเมื่อ 2018-05-01 12:00",
              style: TextStyle(fontSize: 18.0)),
        ),
        ListTile(
          title: new Text(
            "ลบข้อมูลในเครื่อง",
            style: TextStyle(
                fontSize: 23.0, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          subtitle: new Text("ลบข้อมูลที่บันทึกไว้ในเครื่องออกทั้งหมด",
              style: TextStyle(fontSize: 18.0)),
        )
      ],
    );

    return new Scaffold(
        appBar: AppBar(
          title: Text('สมุดสุขภาพประจำตัวประชาชน'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.note_add),
              onPressed: () {
                Navigator.of(context).pushNamed('/activities/add');
              },
            ),
            PopupMenuButton<String>(
              onSelected: mainMenuSelection,
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                const PopupMenuItem<String>(
                    value: 'EDIT_PERSON',
                    child: const Text(
                      'ประวัติการบันทึกข้อมูล',
                      style: TextStyle(fontSize: 20.0),
                    )),
                const PopupMenuItem<String>(
                    value: 'CHANGE_PASSWORD',
                    child: const Text('เปลี่ยนรหัสผ่าน',
                        style: TextStyle(fontSize: 20.0))),
                const PopupMenuItem<String>(
                    value: 'SIGNOUT',
                    child: const Text('ออกจากโปรแกรม',
                        style: TextStyle(fontSize: 20.0))),
              ],
            ),
          ],
        ),
        body: new PageView(
            children: [
              Dashboard(),
              _service,
              _settings,
            ],

            /// Specify the page controller
            controller: _pageController,
            onPageChanged: onPageChanged),
        bottomNavigationBar: new BottomNavigationBar(
            items: [
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.dashboard),
                  title: new Text(
                    "หน้าหลัก",
                    style: TextStyle(fontSize: 18.0),
                  )),
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.notifications_active),
                  title: new Text("บริการ", style: TextStyle(fontSize: 18.0))),
              new BottomNavigationBarItem(
                  icon: new Icon(Icons.settings),
                  title: new Text("ตั้งค่า", style: TextStyle(fontSize: 18.0))),
            ],

            /// Will be used to scroll to the next page
            /// using the _pageController
            onTap: navigationTapped,
            currentIndex: _page)
    );
  }

  void navigationTapped(int page) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }
}
