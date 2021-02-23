import 'package:flutter/material.dart';
import 'package:flutter_jsontest/models/model_question.dart';

class ScreenSubmit extends StatelessWidget {

  final String examName;
  final List<ModelQuestion> modelList;
  final String psyOnlineCode;

  ScreenSubmit(this.examName,this.modelList,this.psyOnlineCode);

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar( //상단바
        title: Text(examName),
      ),

      body: Container(
        child: Center(
          child: FutureBuilder(

          ),
        ),
      ),
    );
  }
}
