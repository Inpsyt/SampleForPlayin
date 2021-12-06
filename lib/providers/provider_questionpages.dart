import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:playinsample/common/common_networkservice.dart';
import 'package:playinsample/models/model_questionchoice.dart';
import 'package:playinsample/models/model_userInfo.dart';

import '../models/model_answer.dart';
import '../models/model_question.dart';

class ProviderQuestionPages extends ChangeNotifier {
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

  void setFloatingCircleSize(double size) {
    this._floatingCircleSize = size;
    notifyListeners();
  }

  int _floatingCircleChildText = 1;

  int getFloatingCircleChildText() => this._floatingCircleChildText;

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

  Future<List<ModelQuestion>> getInpsytQuestionJson(
      String psyOnlineCode, ModelUserInfo userInfo) async {
    _commonNetworkService = CommonNetworkService();
    //https://inpsyt.co.kr/inpsyt/testing/ac2846e8823246c083ad
    await _commonNetworkService
        .get('https://inpsyt.co.kr/inpsyt/testing/${psyOnlineCode}');
    print('provider_questionpages : get 1회 호출');

    await _commonNetworkService
        .get('https://inpsyt.co.kr/inpsyt/testing/${psyOnlineCode}');
    print('provider_questionpages : get 2회 호출');

    //사용자 정보 입력
    await _commonNetworkService.post(
        'https://inpsyt.co.kr/testing/personalDataAddProcess?'
            'userTestingNo'
            '&atTypeCd=0004'
            '&psyItemVer=V1.0'
            '&directionsUseYn=N'
            '&subPsyItemId=00240083'
            '&atAgeCd=0048'
            '&addInquiryValVO.addInquiryValJson'
            '&psyItemId=KPRQ_CO_PG_P'
            '&sessionMemberNo=MEM00000000000099396&schId'
            '&stuHakbun&testerName=서비스기획팀'
            '&testingDate=2021-03-15'
            '&testingOrg=${userInfo.groupName}'
            '&name=${userInfo.testerName}'
            '&birthday=2017-03-07'
            '&sex=M'
            '&atRegionCd=0008'
            '&psyTerminalCd=PC'
            '&psyTerminalBrowserCd=chrome');
    print('provider_questionpages : post 1회 호출');

    //문항JSON파일 내려받기
    String jsons = await _commonNetworkService.post(
        'https://inpsyt.co.kr/testing/questionListAjax?paperJson&atProgressRate&atTemplateCd=0003&atTypeCd=0004&userTestingNo=${psyOnlineCode}&psyItemId=KPRQ_CO_PG_P&psyItemVer=V1.0&subPsyItemId=00240083&yyyymm=202103&schId&psyTerminalCd=PC&psyTerminalBrowserCd=chrome');

    print('provider_questionpages : post 2회 호출');

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

  Future<String> submitInpsytQuestionChoice(
      String psyOnlineCode, List<ModelQuestionChoice> qcList) async {
    List _qcList = new List();

    for (int i = 0; i < qcList.length; i++) {
      _qcList.add({
        "questionNo": i,
        "choiceNo": qcList[i].choiceNo,
        "choiceScore": qcList[i].choiceScore
      });
    }

    String convertedJson = 'paperJson=' +
        Uri.encodeQueryComponent(json.encode({'questionChoiceList': _qcList})) +
        '&atProgressRate=' + '' +
        '&atTemplateCd=' + '0003' +
        '&atTypeCd=' + '0004' +
        '&userTestingNo=' + psyOnlineCode +
        '&psyItemId=' + 'KPRQ_CO_PG_P' +
        '&psyItemVer=' + 'V1.0' +
        '&subPsyItemId=' + '00240083' +
        '&yyyymm=' + '202103' +
        '&schId=' + '';

    for (int i = 0; i < _qcList.length; i++) {
      convertedJson += '&${i + 1}=${_qcList[i]['choiceNo']}';
    }
    for (int i = 0; i < _qcList.length; i++) {
      convertedJson += '&arrayScaleManageScore=${_qcList[i]['choiceScore']}';
    }

    convertedJson += '&psyTerminalCd=PC&psyTerminalBrowserCd=chrome';

    //return(convertedJson);

    //String postData = 'paperJson=%7B%22questionChoiceList%22%3A%5B%7B%22questionNo%22%3A1%2C%22choiceNo%22%3A%220%22%2C%22choiceScore%22%3A%220%22%7D%2C%7B%22questionNo%22%3A2%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A3%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%2C%7B%22questionNo%22%3A4%2C%22choiceNo%22%3A%223%22%2C%22choiceScore%22%3A%223%22%7D%2C%7B%22questionNo%22%3A5%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A6%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%2C%7B%22questionNo%22%3A7%2C%22choiceNo%22%3A%223%22%2C%22choiceScore%22%3A%223%22%7D%2C%7B%22questionNo%22%3A8%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%2C%7B%22questionNo%22%3A9%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A10%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A11%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%2C%7B%22questionNo%22%3A12%2C%22choiceNo%22%3A%223%22%2C%22choiceScore%22%3A%223%22%7D%2C%7B%22questionNo%22%3A13%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A14%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A15%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%2C%7B%22questionNo%22%3A16%2C%22choiceNo%22%3A%223%22%2C%22choiceScore%22%3A%223%22%7D%2C%7B%22questionNo%22%3A17%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A18%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%2C%7B%22questionNo%22%3A19%2C%22choiceNo%22%3A%223%22%2C%22choiceScore%22%3A%223%22%7D%2C%7B%22questionNo%22%3A20%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A21%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%2C%7B%22questionNo%22%3A22%2C%22choiceNo%22%3A%223%22%2C%22choiceScore%22%3A%223%22%7D%2C%7B%22questionNo%22%3A23%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A24%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%2C%7B%22questionNo%22%3A25%2C%22choiceNo%22%3A%223%22%2C%22choiceScore%22%3A%223%22%7D%2C%7B%22questionNo%22%3A26%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A27%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%2C%7B%22questionNo%22%3A28%2C%22choiceNo%22%3A%223%22%2C%22choiceScore%22%3A%223%22%7D%2C%7B%22questionNo%22%3A29%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A30%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%2C%7B%22questionNo%22%3A31%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A32%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%2C%7B%22questionNo%22%3A33%2C%22choiceNo%22%3A%223%22%2C%22choiceScore%22%3A%223%22%7D%2C%7B%22questionNo%22%3A34%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A35%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%2C%7B%22questionNo%22%3A36%2C%22choiceNo%22%3A%223%22%2C%22choiceScore%22%3A%223%22%7D%2C%7B%22questionNo%22%3A37%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A38%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%2C%7B%22questionNo%22%3A39%2C%22choiceNo%22%3A%223%22%2C%22choiceScore%22%3A%223%22%7D%2C%7B%22questionNo%22%3A40%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A41%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%2C%7B%22questionNo%22%3A42%2C%22choiceNo%22%3A%223%22%2C%22choiceScore%22%3A%223%22%7D%2C%7B%22questionNo%22%3A43%2C%22choiceNo%22%3A%221%22%2C%22choiceScore%22%3A%221%22%7D%2C%7B%22questionNo%22%3A44%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%2C%7B%22questionNo%22%3A45%2C%22choiceNo%22%3A%222%22%2C%22choiceScore%22%3A%222%22%7D%5D%7D&atProgressRate=&atTemplateCd=0003&atTypeCd=0004&userTestingNo=${psyCode}&psyItemId=KPRQ_CO_PG_P&psyItemVer=V1.0&subPsyItemId=00240083&yyyymm=202103&schId=&1=0&2=1&3=2&4=3&5=1&6=2&7=3&8=2&9=1&10=1&11=2&12=3&13=1&14=1&15=2&16=3&17=1&18=2&19=3&20=1&21=2&22=3&23=1&24=2&25=3&26=1&27=2&28=3&29=1&30=2&31=1&32=2&33=3&34=1&35=2&36=3&37=1&38=2&39=3&40=1&41=2&42=3&43=1&44=2&45=2&arrayScaleManageScore=0&arrayScaleManageScore=1&arrayScaleManageScore=2&arrayScaleManageScore=3&arrayScaleManageScore=1&arrayScaleManageScore=2&arrayScaleManageScore=3&arrayScaleManageScore=2&arrayScaleManageScore=1&arrayScaleManageScore=1&arrayScaleManageScore=2&arrayScaleManageScore=3&arrayScaleManageScore=1&arrayScaleManageScore=1&arrayScaleManageScore=2&arrayScaleManageScore=3&arrayScaleManageScore=1&arrayScaleManageScore=2&arrayScaleManageScore=3&arrayScaleManageScore=1&arrayScaleManageScore=2&arrayScaleManageScore=3&arrayScaleManageScore=1&arrayScaleManageScore=2&arrayScaleManageScore=3&arrayScaleManageScore=1&arrayScaleManageScore=2&arrayScaleManageScore=3&arrayScaleManageScore=1&arrayScaleManageScore=2&arrayScaleManageScore=1&arrayScaleManageScore=2&arrayScaleManageScore=3&arrayScaleManageScore=1&arrayScaleManageScore=2&arrayScaleManageScore=3&arrayScaleManageScore=1&arrayScaleManageScore=2&arrayScaleManageScore=3&arrayScaleManageScore=1&arrayScaleManageScore=2&arrayScaleManageScore=3&arrayScaleManageScore=1&arrayScaleManageScore=2&arrayScaleManageScore=2&psyTerminalCd=PC&psyTerminalBrowserCd=chrome';

    await Future.delayed(Duration(milliseconds: 1000));
    String result = await _commonNetworkService.post(
        'https://inpsyt.co.kr/testing/questionAnswerAddProcess',
        body: convertedJson,
        encoding: Encoding.getByName('utf-8'));

    //_commonNetworkService = new CommonNetworkService();
    return result;

    //return await fetchSubmitPost(_body);
  }
}
