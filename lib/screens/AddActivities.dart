import 'package:flutter/material.dart';
import 'package:h4u/screens/HomeScreenHos.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:h4u/screens/DetailPage.dart';

class AddActivities extends StatefulWidget {
  String _hcode;
  String _email;

  AddActivities(this._hcode, this._email);

  @override
  _AddActivitiesState createState() =>
      new _AddActivitiesState(this._hcode, this._email);
}

class _AddActivitiesState extends State<AddActivities> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _hcode;
  String _email;
  int idx = 1;
  var _services;
  bool _isLoading = true;

  _AddActivitiesState(this._hcode, this._email);

  void navigateHome(int i) {
    if (i == 0) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new HomeScreenHos(_hcode, _email)));
    }
  }

  @override
  void initState() {
    super.initState();

    _getServices();
  }

  Future<Null> _getServices() async {
    String _hcode = this._hcode;
    var url =
        "http://203.157.102.103:443/api/phr/v1/hospital/request/user/header?hcode=" +
            _hcode;
    var response = await http.get(url);
    var jsonResponse = json.decode(response.body);

    print(jsonResponse['rows']);

    setState(() {
      _services = jsonResponse['rows'];
      _isLoading = false;
    });
  }

  Future<Null> _getTotalDetail(uid) async {}

  void _showLoading() {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
// duration: new Duration(seconds: 4),
      content: new Row(
        children: <Widget>[
          new CircularProgressIndicator(),
          Text(' กรุณารอซักครู่...')
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          centerTitle: true,
          title:
              const Text('H4U for Hospital', style: TextStyle(fontSize: 25.0)),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.teal,
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
        ),
        bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Colors.white,
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
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
              navigateHome(i);
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
          padding: new EdgeInsets.all(10.0),
          child: Center(
            child: _isLoading
                ? CircularProgressIndicator()
                : new ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var titleName =
                          this._services[index]["name"]["title_name"] ?? "";
                      var firstName =
                          this._services[index]["name"]["first_name"] ?? "";
                      var lastName =
                          this._services[index]["name"]["last_name"] ?? "";
                      return new FlatButton(
                        child: new ItemList(titleName, firstName, lastName),
                        onPressed: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new DetailPage(
                                    this._services[index]["hcode"],
                                    this._services[index]["uid"])),
                          );
                        },
                      );
                    },
                    itemCount:
                        this._services != null ? this._services.length : 0,
                  ), //
          ),
        ));
  }
}

class ItemList extends StatelessWidget {
  var tName;
  var fName;
  var lName;

  ItemList(this.tName, this.fName, this.lName);

  @override
  Widget build(BuildContext context) {
    if (this.fName == null || this.lName == null) return Text("");
    return new Card(
      child: ListTile(
        title: new Text(this.tName + this.fName + ' ' + this.lName,
            style: new TextStyle(fontSize: 25.0)),
        subtitle: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Row(
              children: <Widget>[
                Icon(
                  Icons.search,
                  color: Colors.teal,
                  size: 15.0,
                ),
                Expanded(
                  child: new Text("ดูรายละเอียด",
                      style: TextStyle(fontSize: 18.0)),
                ),
//              Icon(
//                Icons.timelapse,
//                color: Colors.orange,
//                size: 15.0,
//              ),
//              Expanded(
//                child: new Text("รอการส่งข้อมูล : 1",
//                    style: TextStyle(fontSize: 18.0)),
//              ),
//              Icon(
//                Icons.search,
//                color: Colors.black,
//                size: 15.0,
//              ),
//              Expanded(
//                child: new Text("ข้อมูลไม่ครบถ้วน : 1",
//                    style: TextStyle(fontSize: 18.0)),
//              )
              ],
            )
          ],
        ),
//      trailing: Icon(Icons.arrow_forward),
        leading: Icon(Icons.info, color: Colors.teal),
      ),
    );
  }
}
