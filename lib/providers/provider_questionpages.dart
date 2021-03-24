

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:playinsample/common/common_networkservice.dart';
import 'package:playinsample/models/model_userInfo.dart';

import '../models/model_answer.dart';
import '../models/model_question.dart';

class ProviderQuestionPages extends ChangeNotifier{

  int _scrollPosition = -1;
  int getScrollPosition() => this._scrollPosition;
  void setScrollPosition(int position) {
    this._scrollPosition = position;
    notifyListeners();
  }

  int _dynamicDuration = 1000;
  int getDynamicDuration() => this._dynamicDuration;
  void setDynamicDuration(int duration) {
    this._dynamicDuration = duration;
    notifyListeners();
  }

  double _floatingCircleSize = 180;
  double getFloatingCircleSize() => this._floatingCircleSize;
  void setFloatingCircleSize(double size){
    this._floatingCircleSize = size;
    notifyListeners();
  }


  int _floatingCircleChildText = 1;
  int getFloatingCircleChildText()  => this._floatingCircleChildText;
  void setFloatingCircleChildText(int num) {
    this._floatingCircleChildText = num;
    notifyListeners();
  }

  double _soundLevel = 0.0;
  double getSoundLevel() => this._soundLevel;
  void setSoundLevel(double level) {
    this._soundLevel = level;
    notifyListeners();
  }


  CommonNetworkService _commonNetworkService;
  Future<List<ModelQuestion>> getInpsytQuestionJson(String psyOnlineCode,ModelUserInfo userInfo) async {
    _commonNetworkService = CommonNetworkService();
    //https://inpsyt.co.kr/inpsyt/testing/ac2846e8823246c083ad
    await _commonNetworkService.get('https://inpsyt.co.kr/inpsyt/testing/${psyOnlineCode}');
    await _commonNetworkService.get('https://inpsyt.co.kr/inpsyt/testing/${psyOnlineCode}');
    await _commonNetworkService.post('https://inpsyt.co.kr/testing/personalDataAddProcess?userTestingNo&atTypeCd=0004&psyItemVer=V1.0&directionsUseYn=N&subPsyItemId=00240083&atAgeCd=0048&addInquiryValVO.addInquiryValJson&psyItemId=KPRQ_CO_PG_P&sessionMemberNo=MEM00000000000099396&schId&stuHakbun&testerName=Im the best&testingDate=2021-03-15&testingOrg&name=${userInfo.name}&birthday=2017-03-07&sex=M&atRegionCd=0008&psyTerminalCd=PC&psyTerminalBrowserCd=chrome');
    String jsons = await _commonNetworkService.post('https://inpsyt.co.kr/testing/questionListAjax?paperJson&atProgressRate&atTemplateCd=0003&atTypeCd=0004&userTestingNo=${psyOnlineCode}&psyItemId=KPRQ_CO_PG_P&psyItemVer=V1.0&subPsyItemId=00240083&yyyymm=202103&schId&psyTerminalCd=PC&psyTerminalBrowserCd=chrome');


    final jsonResult = json.decode(jsons);

    List<ModelQuestion> modelQuestionList = new List<ModelQuestion>();

    for (int i = 0; i < jsonResult["questionList"].length; i++) {
      ModelQuestion modelQuestion = new ModelQuestion(); //리스트 하나의 아이템
      final questionItem = jsonResult["questionList"][i]; //원본의 하나 아이템

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

    return modelQuestionList;

  }

}