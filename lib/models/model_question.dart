import 'package:flutter_jsontest/models/model_answer.dart';

class ModelQuestion{

  List<ModelAnswer> questionChoiceList;
  int questionNo;
  String reactionTitle;

  ModelQuestion({this.questionChoiceList,this.questionNo,this.reactionTitle});

}