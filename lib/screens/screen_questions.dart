import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:playinsample/models/model_answer.dart';
import 'package:playinsample/models/model_question.dart';
import 'package:playinsample/models/model_questionchoice.dart';
import 'package:playinsample/screens/screen_submit.dart';


class Post {
  dynamic questionList;
  dynamic psyOnlineCode;

  Post({this.questionList, this.psyOnlineCode});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      //json에서의 최상위/리스트중 번호/해당 문항의 제목
        questionList: json['questionList'],
        psyOnlineCode: json['psyOnlineCode']);
  }
}

Future<Post> fetchPost(var body) async {
  final url =
      "https://dev.inpsyt.co.kr/front/openApi/test_sampleAPI_aim/selectAPIQuestionList";

  // final Map<String, String> headers = {
  //   'Content-Type': 'application/json;charset=utf-8'
  // };

  final response = await http.post(url, body: body);

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

  Future<List<ModelQuestion>> _fQuestionList;
  List<ModelQuestion> _questionList;
  Future<Post> _post;
  String _psyOnlineCode;

  _ScreenQuestionsState(this.body, this.examName);

  @override
  void initState() {
    // TODO: implement initState

    _fQuestionList = _fromPost(); //Post로부터 받은 json을 List화로 만들어줌

    _post.then((value) {
      //중요한 코드 저장
      _psyOnlineCode = value.psyOnlineCode.toString();
      print('psyOnlineCoce : ' + _psyOnlineCode);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //상단바
        title: Text(examName),
        actions: [
          FlatButton(
              onPressed: () {
                _submit();
              },
              child: Text(
                '제출',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ))
        ],
      ),
      body: FutureBuilder<List<ModelQuestion>>(
        future: _fQuestionList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _questionList = snapshot.data;

            return ListView.builder(
              //문항리스트
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: _questionList.length,
                itemBuilder: (context, index) {
                  List<ModelAnswer> aList =
                      _questionList[index].questionChoiceList;

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
                          _questionList[index].reactionTitle,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        ListView.builder(
                          //답변리스트
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: aList.length,
                            itemBuilder: (context, index2) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: RaisedButton(
                                    color: aList[index2].isChoosen
                                        ? Colors.blueAccent
                                        : Colors.lightBlueAccent,
                                    onPressed: () {
                                      for (int i = 0; i < aList.length; i++) {
                                        _questionList[index]
                                            .questionChoiceList[i]
                                            .isChoosen = false;
                                        //선택이 될때마다 future안에 있는 List들의 isChoosen 을 모두 false로 바꿔주고
                                      }
                                      setState(() {
                                        _questionList[index]
                                            .questionChoiceList[index2]
                                            .isChoosen =
                                        true; //선택한 index2 값의 isChoosen 하나만 true로 바꾸고 setState()
                                      });
                                    },
                                    child: Padding(
                                        padding:
                                        EdgeInsets.symmetric(vertical: 10),
                                        child: Text(
                                            aList[index2].choiceDirection))),
                              );

                              /*
                              return InkWell(
                                highlightColor: Colors.blueAccent,
                                  splashColor: Colors.blueGrey,
                                onTap: (){

                                },
                                child: WidgetRadioBtn(aList[index2]),
                              );

                               */
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

  Future<List<ModelQuestion>> _fromPost() async {
    List<ModelQuestion> modelQuestionList = new List<ModelQuestion>();
    _post = fetchPost(body);

    //여기서 해당 쓰레드가 끝날때까지 기다려줘야 fromPost에 값이 return되는 것이고 그래야 futureBuilder에서 데이터를 감지하는 것
    await _post.then((value) {
      //문항에 대한 리스트화
      for (int i = 0; i < value.questionList.length; i++) {
        ModelQuestion modelQuestion = new ModelQuestion(); //리스트 하나의 아이템
        final questionItem = value.questionList[i]; //원본의 하나 아이템

        modelQuestion.questionNo = questionItem['questionNo']; //각각 대입
        modelQuestion.reactionTitle = questionItem['reactionTitle'];
        modelQuestion.questionChoiceList = new List<ModelAnswer>();

        //print(questionItem['reactionTitle']);

        //답변에 대한 리스트화
        for (int j = 0; j < questionItem['questionChoiceList'].length; j++) {
          ModelAnswer modelAnswer = new ModelAnswer();
          final answerItem = questionItem['questionChoiceList'][j];

          modelAnswer.choiceNo = answerItem['choiceNo']; //마찬가지로 각각 대입
          modelAnswer.choiceScore = answerItem['choiceScore'];
          modelAnswer.choiceDirection = answerItem['choiceDirection'];
          modelAnswer.isChoosen = false;

          //print(answerItem['choiceDirection']);

          modelQuestion.questionChoiceList.add(modelAnswer);
        }

        modelQuestionList.add(modelQuestion);
      }
    });

    return modelQuestionList;
  }

  List<ModelQuestionChoice> _toQuestioinChoiceList(
      //원본문항리스트에서 문항+결과만 분리하는 작업
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

  void _submit() {
    _fQuestionList.then((value) { //_fQuestionList가 불러왔을때 실행되고 그전엔 암것도 못하게
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
            return new ScreenSubmit(
                examName, _toQuestioinChoiceList(_questionList), _psyOnlineCode);
          }));
    });
  }
}
