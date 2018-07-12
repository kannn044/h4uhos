import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:h4u/screens/AddActivities.dart';
import 'package:intl/intl.dart';

class HomeScreenHos extends StatefulWidget {
  String _hcode;
  String _email;

  HomeScreenHos(this._hcode, this._email);

  @override
  _HomeScreenHosState createState() =>
      new _HomeScreenHosState(this._hcode, this._email);
}

class _HomeScreenHosState extends State<HomeScreenHos> {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

//  initailizeDateFormatting("th_TH",null).then(()=>)
  _HomeScreenHosState(this._hcode, this._email);

  String _hcode;
  String _email;
  var _services;
  int idx = 0;
  bool _isLoading = true;

  void _getServices(String _hcode) async {
    var url = "http://203.157.102.103:443/api/phr/v1/service/hospital/request";
    var response =
        await http.post(url, body: {"hcode": _hcode, "status": "wait"});
    var jsonResponse = json.decode(response.body);
    print(jsonResponse['rows']);
    setState(() {
      _services = jsonResponse['rows'];
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _getServices(this._hcode);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
//      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
//        print("Push Messaging token: $token");
        _pushToken(token);
      });
    });
  }

  void _pushToken(String token) async {
    var url = "http://203.157.102.103:443/api/phr/v1/noti/hospital";
    var params = {
      "token": token ?? '',
      "hcode": _hcode ?? '',
      "email": this._email
    };

    var response = await http.post(url, body: params);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
    } else {
      print('error');
    }
  }

  void navigateSearch(int i) {
    if (i == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => new AddActivities(_hcode, _email)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            centerTitle: true,
            title: const Text(
              'H4U for Hospital',
              style: TextStyle(fontSize: 25.0),
            ),
            actions: <Widget>[
              Column(
                children: <Widget>[
                  new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/login');
                        },
                        iconSize: 30.0,
                      )
                    ],
                  )
                ],
              )
            ],
            automaticallyImplyLeading: false,
            backgroundColor: Colors.teal),
        bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              primaryColor: Colors.teal,
              textTheme: Theme
                  .of(context)
                  .textTheme
                  .copyWith(caption: new TextStyle(color: Colors.black26))), //
          child: new BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: idx,
            onTap: (int i) {
              setState(() {
                idx = i;
              });
              navigateSearch(i);
            },
            items: [
              new BottomNavigationBarItem(
                icon: new Icon(Icons.person_add),
                title: new Text("รายชื่อรอการตอบรับ"),
              ),
              new BottomNavigationBarItem(
                icon: new Icon(Icons.search),
                title: new Text("ค้นหาข้อมูลผู้ป่วย"),
              )
            ],
          ),
        ),
        body: new Padding(
          padding: new EdgeInsets.all(15.0),
          child: Center(
            child: _isLoading
                ? CircularProgressIndicator()
                : new ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var dateServe = this._services[index]["date_serve"] ?? "";
                      var dateRequest =
                          this._services[index]["date_request"] ?? "";
                      var cid = this._services[index]["cid"] ?? "";
                      var titleName =
                          this._services[index]["name"]["title_name"] ?? "";
                      var firstName =
                          this._services[index]["name"]["first_name"] ?? "";
                      var lastName =
                          this._services[index]["name"]["last_name"] ?? "";
                      var status = this._services[index]["status"] ?? "";
                      return new FlatButton(
                          onPressed: () {},
                          child: new ItemList(dateServe, dateRequest, cid,
                              titleName, firstName, lastName, status));
                    },
                    itemCount:
                        this._services != null ? this._services.length : 0,
                  ), //
          ),
        ));
  }
}

class ItemList extends StatelessWidget {
  var dRequest;
  var dServe;
  var cid;
  var tName;
  var fName;
  var lName;
  var status;

  ItemList(this.dServe, this.dRequest, this.cid, this.tName, this.fName,
      this.lName, this.status);

  @override
  Widget build(BuildContext context) {
    if (this.cid == null || this.fName == null || this.lName == null)
      return Text("");
    var date = DateTime.parse(this.dRequest);
    var dates = DateTime.parse(this.dServe);
    this.dRequest = new DateFormat.MMMd("th_TH")
        .format(new DateTime(date.year, date.month, date.day));
    this.dServe = new DateFormat.MMMd("th_TH")
        .format(new DateTime(dates.year, dates.month, dates.day));
    return new Card(
      child: ListTile(
        title: new Text("วันที่รับบริการ " + this.dServe + " ${date.year+543}",
            style: new TextStyle(fontSize: 25.0)),
        subtitle: new Text(
            "บัตรประจำตัวประชาชน : " +
                this.cid +
                "\n" +
                this.tName +
                this.fName +
                ' ' +
                this.lName +
                "     " +
                "วันที่ขอรับบริการ " +
                this.dRequest,
            style: new TextStyle(fontSize: 20.0)),
//      trailing: Icon(Icons.arrow_forward),
        leading: Icon(Icons.notifications_active, color: Colors.redAccent),
      ),
    );
  }
}
