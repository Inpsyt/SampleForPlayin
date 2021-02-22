import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_jsontest/models/model_answer.dart';
import 'package:flutter_jsontest/screens/widget/buttonRadioItem.dart';
import 'package:http/http.dart' as http;

Future<Post> fetchPost(var body) async {
  final url =
      "https://dev.inpsyt.co.kr/front/openApi/test_sampleAPI_aim/selectAPIQuestionList";
  final Map<String, String> headers = {
    'Content-Type': 'application/json;charset=utf-8'
  };
  /*
  final body = {
    "key":

    // "김철수KQ|M|20180103|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트|| | |KPRQ_CO_PG_P|MEM00000000000050182|심리검사센터|",
    "김철수H|M|20000101|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트||AT_S_0007|2062|HollandVPI_CO_SG_COL|MEM00000000000050182|심리검사센터|",
    //진로.적성검사

    "addInquiry": "김철수KQ|부"
  };

   */

  final response = await http.post(url,
      //headers:headers,
      body: body);

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.

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

class ScreenQuestions extends StatelessWidget {

  final body;
  final String examName;

  Future<Post> post;

  ScreenQuestions(this.body,this.examName);

  @override
  Widget build(BuildContext context) {

    post = fetchPost(body);


    return  Scaffold(
      appBar: AppBar(
        title: Text(examName), actions: [FlatButton(onPressed: (){}, child: Text('제출',style: TextStyle(color: Colors.white,fontSize: 18),))],
      ),
      body: FutureBuilder<Post>(
        future: post,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // return Text(snapshot.data.questionList);

            List qList = snapshot.data.questionList;

            return ListView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: qList.length,
                itemBuilder: (context, index) {
                  List aList =
                  snapshot.data.questionList[index]['questionChoiceList'];

                  List<ModelAnswer> modelAList = new List<ModelAnswer>();

                  for (var value in aList) {
                    ModelAnswer modelAnswer = ModelAnswer(false,'', value['choiceDirection'].toString());
                    modelAList.add(modelAnswer);
                  }

                  return Container(

                    padding: EdgeInsets.all(20),
                    margin:
                    EdgeInsets.symmetric(horizontal: 18, vertical: 15),

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
                          qList[index]['reactionTitle'].toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: modelAList.length,
                            itemBuilder: (context, index) {
                              return new InkWell(
                                highlightColor: Colors.red,
                                splashColor: Colors.green,
                                onTap: () {

                                    modelAList.forEach((element) => element.isSelected = false);
                                    modelAList[index].isSelected = true;
                                    print('tapped on '+index.toString());

                                },
                                child: new RadioItem(modelAList[index]),
                              );

                              /*
                                  Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    aList[index]['choiceDirection'].toString(),
                                    style: TextStyle(fontSize: 16),
                                  ),
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
}
