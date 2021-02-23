import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_jsontest/models/model_question.dart';
import 'package:flutter_jsontest/models/model_questionchoice.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ScreenSubmit extends StatelessWidget {
  final String examName;
  final List<ModelQuestion> modelList;
  final String psyOnlineCode;

  Future<SubmitPost> _fPost;

  List<ModelQuestionChoice> _qCList =
      new List<ModelQuestionChoice>(); //문제번호,선택한답안을 저장할 곳
  Map<String, dynamic> _body;

  ScreenSubmit(this.examName, this.modelList, this.psyOnlineCode);

  List<Map<String, dynamic>> toPaperJson(List<ModelQuestionChoice> qCList) {
    List<Map<String, dynamic>> paperJson = new List<Map<String, dynamic>>();

    for (int i = 0; i < qCList.length; i++) {
      paperJson.add({
        'questionNo': qCList[i].questionNo,
        'choiceNo': qCList[i].choiceNo,
        'choiceScore': qCList[i].choiceScore
      });
    }

    return paperJson;
  }


  List<ModelQuestionChoice> toQuestioinChoiceList( //원본문항리스트에서 문항+결과만 분리하는 작업
      List<ModelQuestion> modelQuestion) {
    //여기서는 무응답 갯수랑 무응답에 대해 평균값으로 구하는 작업도 해야 함

    List<ModelQuestionChoice> questionChoiceList =
        new List<ModelQuestionChoice>();

    for (int i = 0; i < modelQuestion.length; i++) {
      ModelQuestion questionItem = modelQuestion[i];
      ModelQuestionChoice questionChoiceItem =
          new ModelQuestionChoice(); //questionChoiceList하나를 만들기위해 생성한 아이템 하나
      questionChoiceItem.questionNo = questionItem.questionNo; //그곳에 문제번호부터 입력

      //이쯤에서 미리 무응답에대한 처리 수행
      questionChoiceItem.choiceNo = '3';
      questionChoiceItem.choiceScore = '1'; //임시방편

      for (int j = 0; j < questionItem.questionChoiceList.length; j++) {
        //답이 선택되있는 원본모델

        if (questionItem.questionChoiceList[j].isChoosen) {
          //만약 원본모델을 순회하다가 isChoosen이 true라면..
          questionChoiceItem.choiceNo =
              questionItem.questionChoiceList[j].choiceNo.toString();
          questionChoiceItem.choiceScore =
              questionItem.questionChoiceList[j].choiceScore.toString();
        }
      }
      questionChoiceList.add(questionChoiceItem);
    }

    return questionChoiceList;
  }

  @override
  Widget build(BuildContext context) {
    _qCList = toQuestioinChoiceList(modelList);


    //메소드화 시키기 initBody..
    _body = {
      'psyOnlineCode': psyOnlineCode.toString(), //json이 막상 웹에서 받을땐 string형으로 받음
      'questionCnt': modelList.length.toString(),

      'paperJson':
          {"questionChoiceList": toPaperJson(_qCList).toString()}.toString()

    /*
      'paperJson': {
        "questionChoiceList": [
          {"questionNo": 1, "choiceNo": "1", "choiceScore": "3"},
          {"questionNo": 2, "choiceNo": "2", "choiceScore": "2"},
          {"questionNo": 3, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 4, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 5, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 6, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 7, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 8, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 9, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 10, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 11, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 12, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 13, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 14, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 15, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 16, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 17, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 18, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 19, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 20, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 21, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 22, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 23, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 24, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 25, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 26, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 27, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 28, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 29, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 30, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 31, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 32, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 33, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 34, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 35, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 36, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 37, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 38, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 39, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 40, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 41, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 42, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 43, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 44, "choiceNo": "1", "choiceScore": "0"},
          {"questionNo": 45, "choiceNo": "1", "choiceScore": "0"}
        ]
      }.toString()
      */

    };

    //print(_body);

    _fPost = fetchSubmitPost(_body);

    return Scaffold(
      appBar: AppBar(
        //상단바
        title: Text(examName),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder<SubmitPost>(
            future: _fPost,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              SubmitPost result = snapshot.data;
              return Column(children: [
                Text(result.message.toString()),
                RaisedButton(onPressed: (){
                  _OpenOzViwer(psyOnlineCode);
                }, child: Text('결과보기'))
              ],);
            },
          ),
        ),
      ),
    );
  }
  void _OpenOzViwer(String psyCode) async {
    String url = 'https://dev.inpsyt.co.kr/front/inpsyt/testing/resultMain/'+psyCode+'/HTML5';
    if(await canLaunch(url)) await launch(url);
    else throw 'Could not Launch '+url;

  }

}

class SubmitPost {
  //받으려는 모델
  dynamic message;
  dynamic psyOnlineCode;

  SubmitPost({this.message, this.psyOnlineCode});

  factory SubmitPost.fromJson(Map<String, dynamic> json) {
    return SubmitPost(
        //json에서의 최상위/리스트중 번호/해당 문항의 제목
        message: json['message'],
        psyOnlineCode: json['psyOnlineCode']);
  }
}

Future<SubmitPost> fetchSubmitPost(var body) async {
  final url =
      "https://dev.inpsyt.co.kr/front/openApi/test_sampleAPI_aim/selectAPIMarkingSet";

  final response = await http.post(url, body: body);

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.

    print('제출 성공');

    return SubmitPost.fromJson(json.decode(response.body));
    //throw response.body; //바디의 글자를 전부 출력
  } else {
    // 만약 요청이 실패하면, 에러를 던집니다.

    print('실패');
    throw Exception('Failed to load post');
  }
}

