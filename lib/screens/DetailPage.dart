import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:h4u/screens/AddActivities.dart';
import 'package:intl/intl.dart';
import 'package:h4u/screens/Profiles.dart';

class DetailPage extends StatefulWidget {
  String _request_id;
  String _hcode;

  DetailPage(this._hcode, this._request_id);

  @override
  _DetailPageState createState() =>
      new _DetailPageState(this._hcode, this._request_id);
}

class _DetailPageState extends State<DetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _hcode;
  String _uid;
  String _email;
  var _services;
  bool _isLoading = true;

  _DetailPageState(this._hcode, this._uid);

  void navigateHome() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new AddActivities(_hcode, _email)));
  }

  Future<Null> _getDetail() async {
    String _hcode = this._hcode;
    String _uid = this._uid;

    var url =
        "http://203.157.102.103:443/api/phr/v1/hospital/request/user/headers?uid=" +
            _uid +
            "&hcode=" +
            _hcode;
    var response = await http.get(url);
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

    _getDetail();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          centerTitle: true,
          title: const Text('H4U for Hospital'),
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
        bottomNavigationBar: BottomAppBar(
          hasNotch: true,
          child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                  tooltip: 'กลับ',
                  onPressed: () {
                    setState(() {
                      navigateHome();
                    });
                  },
                ),
              ]),
        ),
        body: new Padding(
          padding: new EdgeInsets.all(10.0),
          child: Center(
            child: _isLoading
                ? CircularProgressIndicator()
                : new ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var dateServe = this._services[index]["date_serve"] ?? "";
                      var status = this._services[index]["status"] ?? "";
                      var titleName =
                          this._services[index]["name"]["title_name"] ?? "";
                      var firstName =
                          this._services[index]["name"]["first_name"] ?? "";
                      var lastName =
                          this._services[index]["name"]["last_name"] ?? "";
                      return new FlatButton(
                        child: new ItemList(
                            dateServe, status, titleName, firstName, lastName),
                        onPressed: () {
                          if (this._services[index]["status"] == "approve") {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      new ProfilesPage(this._services[index])),
                            );
                          }
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
  var dateServe;
  var status;

  ItemList(this.dateServe, this.status, this.tName, this.fName, this.lName);

  @override
  Widget build(BuildContext context) {
    if (this.fName == null || this.lName == null) return Text("");
    var date = DateTime.parse(this.dateServe);
    this.dateServe = new DateFormat.yMMMd("th_TH")
        .format(new DateTime(date.year, date.month, date.day));
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
                new Text("วันที่รับบริการ " + this.dateServe),
              ],
            ),
            new Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    new Text(
                      "สถานะ",
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    new Text(
                        "  " + this.status == 'approve'
                            ? 'ส่งข้อมูลแล้ว'
                            : this.status == 'wait'
                                ? 'รอการส่งข้อมูล'
                                : this.status == 'nodata'
                                    ? 'ข้อมูลไม่ครบถ้วน'
                                    : this.status == 'disapprove'
                                        ? 'ไม่อนุมัติ'
                                        : 'ส่งข้อมูลแล้ว',
                        style: TextStyle(
                            color: this.status == 'approve'
                                ? Colors.green
                                : this.status == 'wait'
                                    ? Colors.orange
                                    : this.status == 'nodata'
                                        ? Colors.red
                                        : this.status == 'disapprove'
                                            ? Colors.brown
                                            : Colors.green))
                  ],
                ),
                Column(
                  children: <Widget>[
                    this.status == 'approve'
                        ? Icon(
                            Icons.search,
                            size: 10.0,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.person,
                            size: 10.0,
                            color: Colors.white,
                          )
                  ],
                )
              ],
            )
          ],
        ),
//      trailing: Icon(Icons.arrow_forward),
        leading: Icon(Icons.flip_to_front, color: Colors.grey),
      ),
    );
  }
}
