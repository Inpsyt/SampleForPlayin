import 'package:flutter/material.dart';
import 'package:playinsample/constants/constant_colors.dart';
import 'package:playinsample/models/model_exam.dart';
import 'package:playinsample/models/model_userInfo.dart';
import 'package:playinsample/providers/provider_appstatus.dart';
import 'package:playinsample/providers/provider_exam.dart';
import 'package:playinsample/screens/screen_profileset.dart';
import 'package:playinsample/screens/screen_questionpages.dart';
import 'package:playinsample/screens/widgets/widget_sidemenu_drawer.dart';
import 'package:provider/provider.dart';

import '../constants/constant_colors.dart';
import '../constants/constant_colors.dart';

class ScreenSelect extends StatelessWidget {

  ValueKey<DateTime> _forceRefresh;

  ProviderExam _providerExam;
  ProviderAppStatus _providerAppStatus;
  PageController _pageController;

  Future<ModelUserInfo> _fModelUserInfo;

  TextEditingController _psyCodeInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('ScreenSelect : 빌드 새로고침');

    _providerExam = Provider.of<ProviderExam>(context, listen: false);

    _providerExam.setOfflineList();

    _providerAppStatus = Provider.of<ProviderAppStatus>(context, listen: true);

    _fModelUserInfo = _providerAppStatus.getUserInfo();

    _fModelUserInfo.then((modelUserInfo)
    {
      _providerExam.setOnlineList(modelUserInfo);
    });

    _pageController = PageController(
      initialPage: _providerExam.getBottomBarPage(),
    );


    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      key: _forceRefresh,
        floatingActionButton: FloatingActionButton(
          onPressed: () {

            _forceRefresh = new ValueKey(DateTime.now());

          },
          backgroundColor: color_charcoal_blue,
          child: Icon(Icons.refresh),
        ),
        bottomNavigationBar: Consumer<ProviderExam>(
          builder: (context, provider, child) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: color_charcoal_blue,
              currentIndex: provider.getBottomBarPage(),
              onTap: (index) {/*
                if (index > _providerExam.getBottomBarPage()) {
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.decelerate);
                } else if (index < _providerExam.getBottomBarPage()) {
                  _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.decelerate);
                }
                */
                _providerExam.setBottomBarPage(index);
                _pageController.jumpToPage(index);
              },
              items: [
                BottomNavigationBarItem(
                    title: Text('샘플서버'), icon: Icon(Icons.all_inbox_sharp)),
                BottomNavigationBarItem(
                    title: Text('정식서버'),
                    icon: Icon(Icons.online_prediction_outlined)),
                BottomNavigationBarItem(
                    title: Text('오프라인'), icon: Icon(Icons.all_inbox_sharp)),
              ],
            );
          },
        ),
        backgroundColor: color_silver_white,
        appBar: AppBar(
          title: Text(
            'Sample for Playin!',
            style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white),
          ),
          backgroundColor: color_charcoal_blue,
          elevation: 0,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ScreenProfileSet();
                  }));
                })
          ],
        ),
        drawer: WidgetSidemenuDrawer(),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                //상단부 영역
                height: screenSize.height / 4.3,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                        offset: Offset(0.1, 0.9))
                  ],
                  color: color_charcoal_blue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: new BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0.1, 0.9),
                                    blurRadius: 10)
                              ],
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/images/profile.jpg')))),
                      SizedBox(
                        height: 13,
                      ),
                      FutureBuilder<ModelUserInfo>(
                        future: _fModelUserInfo,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Container();

                          return Text(
                            snapshot.data.testerName,
                            style: TextStyle(color: Colors.white, fontSize: 23),
                          );
                        },
                      ),
                      Text(
                        '(대학생) 만 23세',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                )),
            Expanded(
              child:

                FutureBuilder<ModelUserInfo>(
                  future: _fModelUserInfo,
                  builder: (context,snapshot){
                    if(!snapshot.hasData)
                      return Center(child: CircularProgressIndicator(),);

                    return  PageView(
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        _providerExam.setBottomBarPage(index);
                      },
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      children: [
                        ListView.builder(
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            itemCount: _providerExam.getOnlineList().length,
                            itemBuilder: (context, index) {
                              ModelExam modelExam =
                              _providerExam.getOnlineList()[index];

                              return _listItem(context, modelExam,snapshot.data);
                            }),
                        ListView(

                          children: [
                            Container(
                              child: Column(

                                children: [
                                  SizedBox(height: 20,),
                                  Text(
                                    '코드입력',
                                    style: TextStyle(
                                        fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20,),
                                  Text(
                                    'KPRQ 유아용 부모자녀관계검사만 가능합니다.',
                                    style: TextStyle(
                                      fontSize: 14,),
                                  ),
                                  SizedBox(height: 40,),
                                  Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 30),
                                      child: TextField(
                                        controller: _psyCodeInputController,
                                        decoration: InputDecoration(
                                          hintText: '온라인 시험 코드를 입력하세요..',
                                          hintStyle: TextStyle(color: Colors.grey),
                                          filled: true,
                                          fillColor: Colors.white70,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(12.0)),
                                            borderSide:
                                            BorderSide(color: color_charcoal_blue, width: 2),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(color: color_charcoal_blue),
                                          ),
                                        ),
                                      )),
                                  SizedBox(height: 20,),
                                  FlatButton(
                                    onPressed: () async{

                                      String psyCode = _psyCodeInputController.text.replaceAll('-', '');
                                      if(psyCode.length!=20)
                                      {
                                        await showDialog(context: context,builder: (context){
                                          return AlertDialog(
                                            title: Text('주의'),
                                            content: Text('코드 형식이 올바르지 않습니다.\n다시입력해 주세요.'),
                                            actions: [
                                              FlatButton(onPressed: (){Navigator.pop(context,true);}, child: Text('OK'))
                                            ],
                                          );
                                        },);

                                        return;
                                      }
                                      _providerExam.setPsyOnlineCode(psyCode);

                                      ModelExam dummyModelExam = ModelExam('반가워요~','');
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (BuildContext context) {
                                            return ScreenQuestionPages(dummyModelExam,snapshot.data);
                                          }));


                                    },
                                    child: Text(
                                      '검사실시',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: color_charcoal_blue,
                                  ),
                                  SizedBox(height: 20,),
                                ],
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 30, vertical: 100),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 8.0,
                                      offset: Offset(0.1, 0.9))
                                ],
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                            physics: BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            itemCount: _providerExam.getOfflineList().length,
                            itemBuilder: (context, index) {
                              ModelExam modelExam =
                              _providerExam.getOfflineList()[index];

                              return _listItem(context, modelExam,snapshot.data);
                            }),
                      ],
                    );
                  },
                )

            ),
          ],
        ));
  }

  Widget _listItem(BuildContext context, ModelExam modelExam,ModelUserInfo modelUserInfo) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: RaisedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return ScreenQuestionPages(modelExam,modelUserInfo);
          }));
        },
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(modelExam.name)),
        color: Colors.white,
        elevation: 3,
      ),
    );
  }
}
