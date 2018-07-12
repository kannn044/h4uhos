import 'package:flutter/material.dart';
//import 'package:h4u/utils/Apis.dart';

import 'package:intl/intl.dart';

class ProfilesPage extends StatefulWidget {
  var detail;
  ProfilesPage(this.detail);

  @override
  _ProfilesPageState createState() => new _ProfilesPageState(this.detail);
}

class _ProfilesPageState extends State<ProfilesPage> {
  var detail;
  _ProfilesPageState(this.detail);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//  Apis api = Apis();

  var drugs = [];
  var labs = [];
  var diagnosis = [];

  var hosName;
  var hosCode;
  var date;
  var time;
  var clinic;
  var screenings = {};
  var sbp = 0;
  var dbp = 0;
  var weight = 0;
  var height = 0;

  var appointment = {};

  void _showLoading() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: new Row(
        children: <Widget>[new CircularProgressIndicator()],
      ),
    ));
  }

  void _setServiceDetail(_detail) async {
    setState(() {
      if (_detail != null) {
        this.time = _detail['time_serve'] ?? '-';

        var _date = DateTime.parse(_detail['date_serve']);
        var strDate = new DateFormat.MMMMd('th_TH')
            .format(new DateTime(_date.year, _date.month, _date.day));

        var _strDate = '$strDate ${_date.year + 543}';

        this.date = _strDate;
        this.clinic = _detail['clinic'] ?? '-';
        this.hosName = _detail['hname'] ?? '-';

        this.screenings = _detail['screening'];

        if (this.screenings != null) {
          this.sbp = this.screenings['sbp'] ?? 0;
          this.dbp = this.screenings['dbp'] ?? 0;
          this.weight = this.screenings['weigth'] ?? 0;
          this.height = this.screenings['height'] ?? 0;
        }

        var drugs = _detail['drugs'];

        if (drugs != null) {
          this.drugs = drugs;
          print(this.drugs);
        }

        var appointment = _detail['appointment'];

        if (appointment != null) {
          this.appointment = appointment;
        }

        var labs = _detail['lab'];

        if (labs != null) {
          this.labs = labs;
        }

        var diagnosis = _detail['diagnosis'] ?? [];

        if (diagnosis != null) {
          this.diagnosis = diagnosis;
          print(this.diagnosis);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print('================');
    print(this.detail);
    _setServiceDetail(this.detail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('H4U for Hospital'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
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
                    Navigator.of(context).pop();
                  });
                },
              ),
            ]),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  '${this.hosName}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                ),
                subtitle: Text(
                  'วันที่ ${this.date} เวลา ${this.time} \nคลิกนิค${this.clinic}',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
          Card(
            child: new Padding(
              padding: const EdgeInsets.all(2.0),
              child: ListTile(
                title: Text(
                  'ข้อมูลการคัดกรอง',
                  style: TextStyle(fontSize: 25.0),
                ),
                subtitle: Text(
                  'ความดันโลหิต ${this.sbp}/${ this.dbp} mmHg.'
                      '\nน้ำหนัก ${this.weight} กก. '
                      'ส่วนสูง ${this.height} ซม.',
                  style: TextStyle(fontSize: 23.0),
                ),
              ),
            ),
          ),
          Card(
            child: new Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('ผลการวินิจฉัย', style: TextStyle(fontSize: 25.0)),
                    ListView.builder(
                      itemBuilder: (context, index) {
                        return Text(
                          '- (${this.diagnosis[index]["icd10_code"] ?? '-'}) ${this.diagnosis[index]["icd10_desc"] ?? '-'} (${this.diagnosis[index]["diage_type"] ?? ''})',
                          style: TextStyle(fontSize: 20.0),
                        );
                      },
                      itemCount: this.diagnosis.length ?? 0,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    ),
                  ],
                )),
          ),
          Card(
            child: new Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('รายการยาที่ได้รับ', style: TextStyle(fontSize: 25.0)),
                    ListView.builder(
                      itemBuilder: (context, index) {
                        return new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '- ${this.drugs[index]["drug_name"] ?? '-'} #${this.drugs[index]["qty"]} ${this.drugs[index]["unit"]}',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Text(
                              '${this.drugs[index]['usage_line1'] ?? ''}',
                              style: TextStyle(fontSize: 18.0),
                            )
                          ],
                        );
                      },
                      itemCount: this.drugs.length ?? 0,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    ),
                  ],
                )),
          ),
          Card(
            child: new Padding(
              padding: const EdgeInsets.all(2.0),
              child: ListTile(
                title: Text(
                  'ผลตรวจทางห้องปฏิบัติการ',
                  style: TextStyle(fontSize: 25.0),
                ),
                subtitle: Text(
                  'รายการผล LAB ${this.labs.length ?? 0} รายการ',
                  style: TextStyle(fontSize: 20.0),
                ),
//                trailing: IconButton(
//                  icon: Icon(Icons.arrow_forward),
//                  onPressed: () {},
//                ),
              ),
            ),
          ),
          Card(
            child: new Padding(
              padding: const EdgeInsets.all(2.0),
              child: ListTile(
                title: Text(
                  'นัดหมายครั้งต่อไป',
                  style: TextStyle(fontSize: 25.0),
                ),
                subtitle: Text(
                  'วันที่นัด ${this.appointment['date'] ?? '-'} เวลา ${this.appointment['time'] ?? '-'}\n'
                      ' แผนก ${this.appointment['clinic'] ?? '-'}',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrugItemList extends StatelessWidget {
  var drugName;
  var amount;
  var unitName;
  var usageLine1;
  var usageLine2;
  var usageLine3;

  DrugItemList(this.drugName, this.amount, this.unitName, this.usageLine1,
      this.usageLine2, this.usageLine3);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: ListTile(
        title:
            new Text(this.drugName ?? '', style: new TextStyle(fontSize: 25.0)),
        subtitle: new Text('''
              จำนวน ${this.amount ?? 0} ${this.unitName??''} \n
              ${this.usageLine1 ?? '-'}\n
              ${this.usageLine2 ?? '-'}\n
              ${this.usageLine3 ?? '-'}
              ''', style: new TextStyle(fontSize: 18.0)),
      ),
    );
  }
}
