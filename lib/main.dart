import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_jsontest/models/model_answer.dart';
import 'package:flutter_jsontest/screens/screen_questions.dart';
import 'package:flutter_jsontest/screens/screen_select.dart';
import 'package:flutter_jsontest/widget/buttonRadioItem.dart';
import 'package:http/http.dart' as http;



void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final body = {
    "key":

    // "김철수KQ|M|20180103|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트|| | |KPRQ_CO_PG_P|MEM00000000000050182|심리검사센터|",
    "김철수H|M|20000101|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트||AT_S_0007|2062|HollandVPI_CO_SG_COL|MEM00000000000050182|심리검사센터|",
    //진로.적성검사

    "addInquiry": "김철수KQ|부"
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScreenSelect()
    );
  }
}
