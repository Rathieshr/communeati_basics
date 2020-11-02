import 'dart:async';

import 'package:communeati_basics/login.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Splash();
}

class _Splash extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 6),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                Login(title: 'Flutter Demo Home Page'))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: new Stack(
        children: [
          new Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(60.0),
            child: Image.asset('assets/images/communeatibasics_logo.png'),
          ),
          new Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset('assets/images/ex_deliver.png'),
            margin: EdgeInsets.only(bottom: 35.0),
          ),
          new Container(alignment: Alignment.bottomCenter,
          child:Text("Everyday needs delivered every morning!",textAlign: TextAlign.center),
            margin: EdgeInsets.only(bottom: 10.0),),
        ],
      ),
    );
  }
}
