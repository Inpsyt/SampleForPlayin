import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_jsontest/models/model_answer.dart';
import 'package:flutter_jsontest/models/model_question.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost(var body) async {
  final url =
      "https://dev.inpsyt.co.kr/front/openApi/test_sampleAPI_aim/selectAPIQuestionList";
  final Map<String, String> headers = {
    'Content-Type': 'application/json;charset=utf-8'
  };

  final response = await http.post(url,
      //headers:headers,
      body: body);

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.

    print('성공');

    return Post.fromJson(json.decode(response.body));
    //throw response.body; //바디의 글자를 전부 출력
  } else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

class Post {
  dynamic questionList;

  Post({this.questionList});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      //json에서의 최상위/리스트중 번호/해당 문항의 제목
      questionList: json['questionList'],
    );
  }
}

class ScreenQuestions extends StatefulWidget {
  final body;
  final String examName;

  ScreenQuestions(this.body, this.examName);

  @override
  _ScreenQuestionsState createState() =>
      _ScreenQuestionsState(this.body, this.examName);
}

class _ScreenQuestionsState extends State<ScreenQuestions> {
  final body;
  final String examName;

  Future<List<ModelQuestion>> _fModelQuestionList;
  Future<Post> post;

  _ScreenQuestionsState(this.body, this.examName);

  @override
  void initState() {
    // TODO: implement initState

    _fModelQuestionList = fromPost();
    super.initState();
  }

  Future<List<ModelQuestion>> fromPost() async {
    List<ModelQuestion> fModelQuestionList = new List<ModelQuestion>();
    post = fetchPost(body);

    //여기서 해당 쓰레드가 끝날때까지 기다려줘야 fromPost에 값이 return되는 것이고 그래야 futureBuilder에서 데이터를 감지하는 것
    await post.then((value) {
      //문항에 대한 리스트화
      for (int i = 0; i < value.questionList.length; i++) {
        ModelQuestion modelQuestion = new ModelQuestion();//리스트 하나의 아이템
        final questionItem = value.questionList[i]; //원본의 하나 아이템

        modelQuestion.questionNo = questionItem['questionNo']; //각각 대입
        modelQuestion.reactionTitle = questionItem['reactionTitle'];
        modelQuestion.questionChoiceList = new List<ModelAnswer>();

        print(questionItem['reactionTitle']);

        //답변에 대한 리스트화
        for (int j = 0; j < questionItem['questionChoiceList'].length; j++) {
          ModelAnswer modelAnswer = new ModelAnswer();
          final answerItem = questionItem['questionChoiceList'][j];

          modelAnswer.choiceNo = answerItem['choiceNo'];
          modelAnswer.choiceScore = answerItem['choiceScore'];
          modelAnswer.choiceDirection = answerItem['choiceDirection'];
          modelAnswer.isChoosen = false;

          print(answerItem['choiceDirection']);

          modelQuestion.questionChoiceList.add(modelAnswer);
        }

        fModelQuestionList.add(modelQuestion);
      }

    });


    return fModelQuestionList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(examName),
        actions: [
          FlatButton(
              onPressed: () {},
              child: Text(
                '제출',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ))
        ],
      ),
      body: StreamBuilder<List<ModelQuestion>>(
        stream: _fModelQuestionList.asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ModelQuestion> qList = snapshot.data;

            return ListView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: qList.length,
                itemBuilder: (context, index) {
                  List<ModelAnswer> aList = qList[index].questionChoiceList;

                  return Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                    decoration: BoxDecoration(
                        color: Color(0xffd7ebfc),
                        //color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 8,
                              offset: Offset(0, 8))
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          qList[index].reactionTitle,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: aList.length,
                            itemBuilder: (context, index2) {
                              return Text(
                                aList[index2].choiceDirection,
                              );
                            })
                      ],
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text("onSnapshotError: ${snapshot.error}");
          }
          // 기본적으로 로딩 Spinner를 보여줍니다.
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
