import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Services extends StatefulWidget {
  String _uid;

  Services(this._uid);

  @override
  _ServicesState createState() => new _ServicesState(this._uid);
}

class _ServicesState extends State<Services> {
  String _uid;
  var _services;
  bool _isLoading = true;

  _ServicesState(this._uid);

  void _getServices() async {
    String uid = this._uid;
    var url = "http://203.157.102.103/api/phr/v1/service?registerId=$uid";
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
    _getServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ประวัติการรับบริการ'),
        ),
        body: Center(
          child: this._isLoading
              ? new CircularProgressIndicator()
              : new ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    var hospitalName = this._services[index]["hname"];
                    var dateServe = this._services[index]["date_serve"];
                    var timeServe = this._services[index]["time_serve"];
                    var status = this._services[index]["status"];
                    return new FlatButton(
                      child: new ItemList(
                          hospitalName, dateServe, timeServe, status),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   new MaterialPageRoute(
                        //       builder: (context) => new DetailPage()),
                        // );
                      },
                    );
                  },
                  itemCount: this._services != null ? this._services.length : 0,
                ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'เพิ่มการร้องขอ',
          child: Icon(Icons.add_a_photo),
          onPressed: () {
            // no action
            //  scan();
          },
        ));
  }
}

class ItemList extends StatelessWidget {
  var hName;
  var date;
  var time;
  var status;

  ItemList(this.hName, this.date, this.time, this.status);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(this.hName, style: new TextStyle(fontSize: 20.0)),
      subtitle: new Text('วันที่ ' + this.date + ' เวลา ' +this.time + ' น.',
          style: new TextStyle(fontSize: 16.0)),
      leading: Icon(
        Icons.notifications_active,
        color: this.status == 'wait'
            ? Colors.grey
            : this.status == 'disapprove' ? Colors.red : Colors.green,
      ),
    );
  }
}
