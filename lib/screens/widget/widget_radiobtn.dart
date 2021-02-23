import 'package:flutter/material.dart';
import 'package:flutter_jsontest/models/model_answer.dart';

class WidgetRadioBtn extends StatelessWidget {
  final ModelAnswer _item;

  WidgetRadioBtn(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      margin: EdgeInsets.all(15.0),
      child: Center(child: Text(_item.choiceDirection)),
    );
  }
}
