import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:http/http.dart' as http;
import 'package:playinsample/constants/constant_colors.dart';
import 'package:playinsample/models/model_questionchoice.dart';
import 'package:playinsample/providers/provider_exam.dart';
import 'package:playinsample/providers/provider_questionpages.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ScreenSubmitInpsyt extends StatelessWidget {

  ProviderExam _providerExam;
  ProviderQuestionPages _providerQuestionPages;

  int mode;
  final String examName;
  final String psyOnlineCode;
  final List<ModelQuestionChoice> qCList; //문제번호,선택한답안을 저장할 곳

  Future<String> _fResult;

  ScreenSubmitInpsyt(this.examName, this.qCList, this.psyOnlineCode);

  @override
  Widget build(BuildContext context) {

    _providerExam = Provider.of<ProviderExam>(context,listen: false);
    _providerQuestionPages = Provider.of<ProviderQuestionPages>(context,listen: false);

    mode = _providerExam.getBottomBarPage();

    _fResult = _providerQuestionPages.submitInpsytQuestionChoice(psyOnlineCode, qCList);

    FadeInController resultBtnFadeController =
        FadeInController(autoStart: false);

    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      resultBtnFadeController.fadeIn();
      timer.cancel();
    });

    return Scaffold(
      backgroundColor: color_charcoal_blue,
      appBar: AppBar(
        //상단바
        elevation: 0,
        backgroundColor: color_charcoal_blue,
      ),
      body: Container(
        child: Center(
          child: FutureBuilder<String>(
            future: _fResult,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }

              String result = snapshot.data;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeIn(
                    child: Text(
                      "수고하셨습니다!",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                    duration: Duration(milliseconds: 1000),
                  ),
                  SizedBox(
                    height: 100,
                  ),



                  FadeIn(
                    duration: Duration(milliseconds: 1000),
                    controller: resultBtnFadeController,
                    child:

                        /*
                    NeumorphicButton(
                        margin: EdgeInsets.only(top: 12),
                        onPressed: () {
                          _OpenOzViwer(psyOnlineCode);
                        },
                        style: NeumorphicStyle(
                          color: color_charcoal_purple,
                          shadowLightColor: color_charcoal_purple_light,
                          shape: NeumorphicShape.flat,
                          boxShape:
                          NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                          //border: NeumorphicBorder()
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 55,vertical: 13),
                        child: Text(
                          "결과 보기",
                          style: TextStyle(color: Colors.white,fontSize: 17),
                        )),

                         */


                    RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                        color: color_charcoal_blue,
                        onPressed: () {
                          _OpenOzViwer(psyOnlineCode);
                        },
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text(
                              '결과보기',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ))),


                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _OpenOzViwer(String psyCode) async {
    String url = 'https://inpsyt.co.kr/inpsyt/testing/result/' +
        psyCode +
        '/HTML5';
    if (await canLaunch(url))
      await launch(url);
    else
      throw 'Could not Launch ' + url;
  }
}

List<Map<String, dynamic>> toPaperJson(List<ModelQuestionChoice> qCList) {
  List<Map<String, dynamic>> paperJson = new List<Map<String, dynamic>>();

  for (int i = 0; i < qCList.length; i++) {
    paperJson.add({
      '"questionNo"': qCList[i].questionNo,
      '"choiceNo"': '"' + qCList[i].choiceNo + '"',
      '"choiceScore"': '"' + qCList[i].choiceScore + '"'
    });
  }

  return paperJson;
}

