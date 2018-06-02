import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTime() async {
    new Timer(new Duration(seconds: 5), navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.pinkAccent
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50.0,
                          child: Icon(
                              Icons.local_activity,
                              color: Colors.greenAccent,
                              size: 50.0
                          ),

                        ),
                        Padding(padding: EdgeInsets.only(top: 10.0),),
                        Text("HEALTH FOR YOU", style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold
                        ),)
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Padding(padding: EdgeInsets.all(10.0),),
                        Text("สมุดสุขภาพประจำตัวประชาชน",
                          style: TextStyle(color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),),
                        Text("ศูนย์เทคโนโลยีสารสนเทศและการสื่อสาร",
                          style: TextStyle(
                              color: Colors.white, fontSize: 16.0),),
                        Text("สำนักงานปลัดกระทรวงสาธารณสุข กระทรวงสาธารณสุข",
                          style: TextStyle(
                              color: Colors.white, fontSize: 16.0),)
                      ],
                    )
                )
              ],
            )
          ],
        )
    );
  }
}
