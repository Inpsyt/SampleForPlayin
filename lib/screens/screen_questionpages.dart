import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:playinsample/constants/constant_colors.dart';
import 'package:playinsample/models/model_answer.dart';
import 'package:playinsample/models/model_exam.dart';
import 'package:playinsample/models/model_question.dart';
import 'package:playinsample/models/model_questionchoice.dart';
import 'package:playinsample/providers/provider_scrollanimation.dart';
import 'package:playinsample/screens/screen_submit.dart';

import 'package:highlight_text/highlight_text.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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

    print('ScreenQuestionPages : 성공 200 ');

    return Post.fromJson(json.decode(response.body));
    //throw response.body; //바디의 글자를 전부 출력
  } else {
    // 만약 요청이 실패하면, 에러를 던집니다.
    throw Exception('Failed to load post');
  }
}

class ScreenQuestionPages extends StatefulWidget {
  final ModelExam _modelExam;

  final bool isOnline;

  ScreenQuestionPages(this._modelExam, this.isOnline);

  @override
  _ScreenQuestionPagesState createState() =>
      _ScreenQuestionPagesState(this._modelExam, this.isOnline);
}

class _ScreenQuestionPagesState extends State<ScreenQuestionPages> {
  final ModelExam _modelExam;
  final bool isOnline;

  final double _paddingHorizontal = 58;

  Future<List<ModelQuestion>> _fQuestionList;
  List<ModelQuestion> _questionList;
  Future<Post> _post;
  String _psyOnlineCode;

  Timer _waitPageTimer;

  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  int _selectedCount = 1;
  bool _isPageChanging = false; 

  //voice recognition 관련 변수
  stt.SpeechToText _speech;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;
  bool _isVoiceRecog = false;

  //dynamic listview 변수
  bool isMoreList = true;
  double _containerHeigh = 0;
  bool isShowing = false;
  ProviderScrollAnimation _providerScrollAnimation;
  ScrollController _scrollController = ScrollController();

  //animation effect
  FadeInController topFadeController = FadeInController(autoStart: false);
  FadeInController middleTopFadeController = FadeInController(autoStart: false);
  FadeInController middleBottomFadeController =FadeInController(autoStart: false);
  FadeInController bottomFadeController = FadeInController(autoStart: false);
  FadeInController centerTextFadeController = FadeInController(autoStart: false);
  int _dynamicDuration = 1000;
  

  _ScreenQuestionPagesState(this._modelExam, this.isOnline);

  @override
  void initState() {
    // TODO: implement initState

    if (isOnline) {
      _fQuestionList = _fromPost(); //Post로부터 받은 json을 List화로 만들어줌
      _post.then((value) {
        //중요한 코드 저장
        _psyOnlineCode = value.psyOnlineCode.toString();
        print('psyOnlineCode : ' + _psyOnlineCode);
      });
    } else {
      _fQuestionList = _fromJson();
      _psyOnlineCode = "97912a1edf07469c9733";
    }

    _scrollController.addListener(() {
       initScrollState();
      });




    _speech = stt.SpeechToText();

    _listenVoice(true);

    super.initState();
  }

  void initScrollState(){
    if(_scrollController.offset >=_scrollController.position.maxScrollExtent){
      _providerScrollAnimation.setScrollPosition(1);//하단에 있는 상태
    }else if(_scrollController.offset <= _scrollController.position.minScrollExtent){
      _providerScrollAnimation.setScrollPosition(-1); //상단에 있는 상태
    }else{
      _providerScrollAnimation.setScrollPosition(0);//중앙에 있는 상태
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    _providerScrollAnimation = Provider.of<ProviderScrollAnimation>(context,listen: false);

    Future.delayed(Duration.zero, () => initScrollState());


    //print('ScreenSize :' + screenSize.width.toString());
    //print('ScreenSize :' + screenSize.height.toString());

    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                  title: Text('정말로 종료하시겠습니까?'),
                  content: Text('진행중인 정보는 저장되지 않습니다.'),
                  actions: [
                    FlatButton(
                      child: Text('NO'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        return;
                      },
                    ),
                    FlatButton(
                      child: Text('YES'),
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    )
                  ],
                ));
      },
      child: Scaffold(
          backgroundColor: color_eui_light,
          appBar: AppBar(
            backgroundColor: color_eui_light,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: color_text_dark,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                          title: Text('정말로 종료하시겠습니까?'),
                          content: Text('진행중인 정보는 저장되지 않습니다.'),
                          actions: [
                            FlatButton(
                              child: Text('NO'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                                return;
                              },
                            ),
                            FlatButton(
                              child: Text('YES'),
                              onPressed: () {
                                Navigator.pop(context, true);
                                Navigator.pop(context, true);
                              },
                            )
                          ],
                        ));
              },
            ),
            actions: [
              /*
              FlatButton(
                  onPressed: () {
                    _submit();
                  },
                  child: Text(
                    '제출',
                    style: TextStyle(color: color_text_dark, fontSize: 18),
                  ))

              */
            ],
          ),
          body: FutureBuilder<List<ModelQuestion>>(
              future: _fQuestionList,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  print("데이터가 로드됨.");

                  _questionList = snapshot.data;
                  _refreshDynamicListView();

                  return Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          //중앙부 막대
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: _paddingHorizontal, vertical: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: double.infinity),

                                /*
                        SliderTheme(
                          data: SliderThemeData(
                            thumbColor: Colors.transparent,
                          ),
                          child: Slider(

                            activeColor: color_charcoal_blue,
                            inactiveColor: color_black_300,
                            value: _currentPage.toDouble(),
                            min: 0,
                            max: _questionList.length.toDouble() - 1,
                            //divisions: _questionList.length, //이상한 점박이들 생김
                            label: (_currentPage.round() + 1).toString(),


                            onChanged: (double value) {
                              setState(() {
                                _currentPage = value.toInt();
                                _pageController.jumpToPage(_currentPage);
                              });
                            },
                          ),
                        )
                         */

                                FadeIn(
                                  controller: topFadeController,
                                  duration: Duration(milliseconds: 1000),
                                  child: LinearPercentIndicator(
                                    percent: (_currentPage + 1) /
                                        _questionList.length.toDouble(),
                                    backgroundColor: color_black_300,
                                    progressColor: color_charcoal_blue,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //상단부 문항 슬라이더
                          Consumer<ProviderScrollAnimation>(
                            builder: (context,provider,child){
                              return  Expanded(

                                child: FadeIn(
                                  controller: middleTopFadeController,
                                  duration: Duration(milliseconds: provider.getDynamicDuration()),
                                  child: PageView.builder(
                                      onPageChanged: (index) {
                                        setState(() {
                                          _currentPage = index;
                                          _refreshDynamicListView(); //리스트뷰 크기 재조정
                                          _speech.stop();
                                          _listenVoice(true);
                                        });
                                      },
                                      controller: _pageController,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: _selectedCount,
                                      itemBuilder: (context, index) {
                                        return Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: _paddingHorizontal),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  child: Text(
                                                    _questionList[index]
                                                        .reactionTitle
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: color_text_dark,
                                                        fontSize: 20,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              );
                             }
                          ),


                          //하단부 선택영역
                          Consumer<ProviderScrollAnimation>(
                            builder: (context,provider,child){
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(

                                    //color: Colors.red,
                                    height: screenSize.height * 1.4 / 3,
                                    child: FadeIn(
                                      controller: middleBottomFadeController,
                                      duration: Duration(milliseconds: provider.getDynamicDuration()),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Stack(
                                            children: [
                                              AnimatedContainer(
                                                duration:
                                                Duration(milliseconds: 500),
                                                curve: Curves.linear,
                                                height: _containerHeigh,
                                                child: Center(
                                                  child: ListView.separated(
                                                      controller: _scrollController,
                                                      physics: isMoreList
                                                          ? BouncingScrollPhysics(
                                                          parent:
                                                          AlwaysScrollableScrollPhysics())
                                                          : NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      separatorBuilder:
                                                          (context, index) {
                                                        return Padding(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal:
                                                              _paddingHorizontal),
                                                          child: Container(
                                                            height: 1,
                                                            color:
                                                            color_trans22_black_300,
                                                          ),
                                                        );
                                                      },
                                                      itemCount: _questionList[
                                                      _currentPage]
                                                          .questionChoiceList
                                                          .length,
                                                      itemBuilder:
                                                          (context, index2) {

                                                        bool isChoosen = _questionList[
                                                        _currentPage]
                                                            .questionChoiceList[
                                                        index2]
                                                            .isChoosen;

                                                        return Padding(
                                                          padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 0),
                                                          child: ListTile(
                                                            tileColor: isChoosen?color_charcoal_blue:Colors.transparent,
                                                            title: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 7,
                                                                  horizontal:
                                                                  _paddingHorizontal -
                                                                      10),
                                                              child: Row(
                                                                mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    (index2 + 1)
                                                                        .toString() +
                                                                        '. ' +
                                                                        _questionList[
                                                                        _currentPage]
                                                                            .questionChoiceList[
                                                                        index2]
                                                                            .choiceDirection
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        18,
                                                                        fontWeight: isChoosen
                                                                            ? FontWeight
                                                                            .bold
                                                                            : FontWeight
                                                                            .w400,
                                                                        color: isChoosen
                                                                            ? Colors.white
                                                                            : color_text_dark),
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    color: _questionList[
                                                                    _currentPage]
                                                                        .questionChoiceList[
                                                                    index2]
                                                                        .isChoosen
                                                                        ? Colors.white
                                                                        : color_trans22_black_300,
                                                                    size: 20,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: () =>
                                                                _onChoiceBtnClicked(
                                                                    index2),
                                                          ),

                                                          /*
                                              FlatButton(
                                                  highlightColor: color_charcoal_purple,
                                                  splashColor: color_charcoal_purple,
                                                  focusColor: color_charcoal_purple,
                                                  color: _questionList[_currentPage]
                                                          .questionChoiceList[index2]
                                                          .isChoosen
                                                      ? color_charcoal_purple
                                                      : Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(color: color_black_600),
                                                      borderRadius: BorderRadius.circular(10)),
                                                  onPressed: () {
                                                    for (int i = 0;
                                                        i <
                                                            _questionList[_currentPage]
                                                                .questionChoiceList
                                                                .length;
                                                        i++) {
                                                      _questionList[_currentPage]
                                                          .questionChoiceList[i]
                                                          .isChoosen = false;
                                                    }
                                                    setState(() {
                                                      _questionList[_currentPage]
                                                          .questionChoiceList[index2]
                                                          .isChoosen = true;
                                                    });

                                                    _pageController.nextPage(
                                                        duration: Duration(milliseconds: 200),
                                                        curve: Curves.decelerate);
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 7),
                                                    child: Text(
                                                      _questionList[_currentPage]
                                                          .questionChoiceList[index2]
                                                          .choiceDirection
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: _questionList[_currentPage]
                                                                  .questionChoiceList[index2]
                                                                  .isChoosen
                                                              ? Colors.white
                                                              : color_black_500),
                                                    ),
                                                  )),


                                              */
                                                        );
                                                      }),
                                                ),
                                              ),
                                              Positioned( //상단부분 그림자
                                                top: -1,
                                                child: AnimatedContainer(
                                                  duration:
                                                  Duration(milliseconds: 200),
                                                  width: 10000,
                                                  height: (provider.getScrollPosition()>-1)&&isMoreList?45:0,
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin:
                                                          Alignment.topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            color_eui_light,
                                                      color_trans66_eui,
                                                          ])),
                                                ),
                                              ),
                                              Positioned( //하단부분 그림자
                                                bottom: -1,
                                                child: AnimatedContainer(
                                                  duration:
                                                  Duration(milliseconds: 200),
                                                  width: 1000,
                                                  height: (provider.getScrollPosition()<1)&&isMoreList?45:0,
                                                  decoration: BoxDecoration(
                                                    boxShadow: [BoxShadow(color: Colors.transparent)],
                                                      gradient: LinearGradient(
                                                          begin:
                                                          Alignment.topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            color_trans66_eui,
                                                            color_eui_light
                                                          ])),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  FadeIn(
                                    duration: Duration(milliseconds: 1000),
                                    controller: bottomFadeController,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 30),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          CupertinoSwitch(
                                            value: _isVoiceRecog,
                                            onChanged: (isChecked) {
                                              setState(() {
                                                _isVoiceRecog = !_isVoiceRecog;
                                              });
                                              _listenVoice(true);
                                            },
                                            activeColor: color_charcoal_blue,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(_isVoiceRecog?'버튼으로만 응답할 수 있어요':'음성으로도 응답할 수 있어요')
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },

                          ),
                        ],
                      ),

                      //중앙의 제목 표시영역
                      FadeIn(
                          duration: Duration(milliseconds: 1000),
                          controller: centerTextFadeController,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                              _modelExam.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )),
                          ))
                    ],
                  );
                }
              })),
    );
  }

  //버튼 클릭에 의해 다음페이지로 이동되게
  void _onChoiceBtnClicked(int index2) {


    if(_isPageChanging){
      return; //페이지 변경이 완전 끝나고 나서 변경이 가능하게
    }

    for (int i = 0;
        i < _questionList[_currentPage].questionChoiceList.length;
        i++) {
      _questionList[_currentPage].questionChoiceList[i].isChoosen = false;
    }
    setState(() {
      _questionList[_currentPage].questionChoiceList[index2].isChoosen = true;
      _refreshDynamicListView();
    });

    _checkSelectedCount();

    _nextPage();
  }


  void _refreshDynamicListView() { //인트로 모션까지 포함
    if (_questionList[_currentPage].questionChoiceList.length > 5) {
      isMoreList = true;
      _containerHeigh = MediaQuery.of(context).size.height / 2 - 100;
    } else {
      isMoreList = false;
      _containerHeigh = 300;
    }

    if (!isShowing) {
      //화면 로드된 후 한번만 실행
      isShowing = true;
      isMoreList = false;
      _containerHeigh = 0;

      Timer(Duration(milliseconds: 700), () {
        centerTextFadeController.fadeIn(); //1초 뒤에 제목 표

        Timer(Duration(milliseconds: 1500), () {
          //2.5초동안 제목 표시하고 페이드아웃
          centerTextFadeController.fadeOut();

          Timer(Duration(milliseconds: 1000), () {
            middleTopFadeController.fadeIn();
          });
          Timer(Duration(milliseconds: 1000), () {
            topFadeController.fadeIn();
          });

          Timer(Duration(milliseconds: 1000), () {
            middleBottomFadeController.fadeIn();
          });
          Timer(Duration(milliseconds: 1000), () {
            bottomFadeController.fadeIn();
          });

          Timer(Duration(milliseconds: 2000), () {
            setState(() {});
          });
        });
      });
    }
  }

  void _checkSelectedCount() {
    int selectedCount = 1;

    if (_currentPage == _questionList.length - 1) //현재 페이지가 마지막 페이지인지 확인
    {
      _submit();
      return;
    }
    for (int j = 0; j < _questionList.length; j++) {
      for (int k = 0; k < _questionList[j].questionChoiceList.length; k++) {
        if (_questionList[j].questionChoiceList[k].isChoosen == true) {
          selectedCount++;
        }
      }
    }
    _selectedCount = selectedCount;


  }



  void _nextPage() {
    //직접사용 금지
    if (_waitPageTimer != null) {
      _waitPageTimer.cancel();
    }
    _isPageChanging = true;
    //_nextPageFader();
    _waitPageTimer = Timer(Duration(milliseconds: 500), () {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.decelerate).then((value) { _isPageChanging = false; });
    });


  }

  void _nextPageFader(){
    _providerScrollAnimation.setDynamicDuration(100);
    middleTopFadeController.fadeOut();
    middleBottomFadeController.fadeOut();

    Timer(Duration(milliseconds: 1300),(){
      _providerScrollAnimation.setDynamicDuration(1000);
      middleTopFadeController.fadeIn();
      middleBottomFadeController.fadeIn();
    });
  }


  void _submit() {
    _fQuestionList.then((value) async {
      //_fQuestionList가 불러왔을때 실행되고 그전엔 암것도 못하게
      await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('제출하시겠습니까?'),
            content: Text(''),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                    return;
                  },
                  child: Text('아니요')),
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(context, false);
                    await Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return new ScreenSubmit(
                          _modelExam.name,
                          _toQuestioinChoiceList(_questionList),
                          _psyOnlineCode);
                    }));
                    Navigator.pop(context, true);
                  },
                  child: Text('예'))
            ],
          );
        },
      );
    });
  }

  void _listenVoice(bool isListen) async {
    _speech.stop();

    if (!_isVoiceRecog) {
      return;
    }

    if (isListen) {
      bool available = await _speech.initialize(
        debugLogging: false,
        onStatus: (val) {
          print('onStatus: $val');
        },
        onError: (val) {
          print('onError: $val');
          _speech.stop();

          Timer(Duration(milliseconds: 50), () {
            _listenVoice(true);
          });
        },
      );
      if (available) {
        _speech.listen(
          //  pauseFor: Duration(seconds: 700),

          localeId: 'ko_KR',
          onResult: (val) {
            _text = val.recognizedWords;

            _checkVoiceResult(_text);

            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          },
        );
      }
    }
  }

  void _checkVoiceResult(String text) {
    print(text);

    if (text.trim().contains('1') || text.trim().contains('일')) {
      _onChoiceBtnClicked(0);
      _speech.stop();
    } else if (text.trim().contains('2') || text.trim().contains('이')) {
      _onChoiceBtnClicked(1);
      _speech.stop();
    } else if (text.trim().contains('3') || text.trim().contains('삼')) {
      _onChoiceBtnClicked(2);
      _speech.stop();
    } else if (text.trim().contains('4') || text.trim().contains('사')) {
      _onChoiceBtnClicked(3);
      _speech.stop();
    } else if (text.trim().contains('5') || text.trim().contains('오')) {
      _onChoiceBtnClicked(4);
      _speech.stop();
    } else if (text.trim().contains('6') || text.trim().contains('육')) {
      _onChoiceBtnClicked(5);
      _speech.stop();
    } else if (text.trim().contains('7') || text.trim().contains('칠')) {
      _onChoiceBtnClicked(6);
      _speech.stop();
    } else if (text.trim().contains('8') || text.trim().contains('팔')) {
      _onChoiceBtnClicked(7);
      _speech.stop();
    } else if (text.trim().contains('9') || text.trim().contains('구')) {
      _onChoiceBtnClicked(8);
      _speech.stop();
    }
    // else{
    //   Timer(Duration(seconds: 3),()
    //   {
    //     _speech.stop();
    //     _listenVoice(true);
    //   });
    // }
  }

  Future<List<ModelQuestion>> _fromPost() async {
    _post = fetchPost(_modelExam.body);

    List<ModelQuestion> modelQuestionList = new List<ModelQuestion>();
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

  Future<List<ModelQuestion>> _fromJson() async {
    String data =
        await rootBundle.loadString('assets/jsons/exam/${_modelExam.testJson}');
    final jsonResult = json.decode(data);

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
}
