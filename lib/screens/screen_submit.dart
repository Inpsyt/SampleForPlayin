import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_jsontest/models/model_question.dart';
import 'package:http/http.dart' as http;


class ScreenSubmit extends StatelessWidget {

  final String examName;
  final List<ModelQuestion> modelList;
  final String psyOnlineCode;

  Future<Post> _fPost;

  Map<String,dynamic> _body;

  ScreenSubmit(this.examName,this.modelList,this.psyOnlineCode);

  @override
  Widget build(BuildContext context) {

    //메소드화 시키기 initBody..
    _body= {
      'psyOnlineCode': psyOnlineCode.toString(), //json이 막상 웹에서 받을땐 string형으로 받음
      'questionCnt' : modelList.length.toString(),
      'paperJson' : {

        "questionChoiceList":
        [
          {
            "questionNo":1,
            "choiceNo":"1",
            "choiceScore":"3"
          },
          {
            "questionNo":2,
            "choiceNo":"2",
            "choiceScore":"2"
          },
          {
            "questionNo":3,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":4,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":5,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":6,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":7,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":8,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":9,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":10,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":11,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":12,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":13,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":14,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":15,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":16,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":17,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":18,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":19,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":20,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":21,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":22,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":23,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":24,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":25,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":26,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":27,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":28,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":29,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":30,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":31,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":32,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":33,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":34,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":35,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":36,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":37,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":38,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":39,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":40,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":41,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":42,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":43,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":44,
            "choiceNo":"1",
            "choiceScore":"0"
          },
          {
            "questionNo":45,
            "choiceNo":"1",
            "choiceScore":"0"
          }
        ]

      }.toString()

    };

    print(_body);

    _fPost = fetchPost(_body);

    return Scaffold(
      appBar: AppBar( //상단바
        title: Text(examName),
      ),

      body: Container(
        child: Center(
          child: FutureBuilder<Post>(
            future: _fPost,
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return CircularProgressIndicator();
              }

              Post result = snapshot.data;
              return Text(result.message.toString());
            },

          ),
        ),
      ),
    );
  }
}

class Post { //받으려는 모델
  dynamic message;
  dynamic psyOnlineCode;

  Post({this.message, this.psyOnlineCode});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      //json에서의 최상위/리스트중 번호/해당 문항의 제목
        message: json['message'],
        psyOnlineCode: json['psyOnlineCode']);
  }
}

Future<Post> fetchPost(var body) async {
  final url = "https://dev.inpsyt.co.kr/front/openApi/test_sampleAPI_aim/selectAPIMarkingSet";

  final response = await http.post(url, body: body);

  if (response.statusCode == 200) {
    // 만약 서버로의 요청이 성공하면, JSON을 파싱합니다.

    print('제출 성공');


    return Post.fromJson(json.decode(response.body));
    //throw response.body; //바디의 글자를 전부 출력
  } else {
    // 만약 요청이 실패하면, 에러를 던집니다.

    print('실패');
    throw Exception('Failed to load post');
  }
}
