import 'package:flutter/material.dart';
import 'package:playinsample/constants/constant_colors.dart';
import 'package:playinsample/models/model_exam.dart';
import 'package:playinsample/providers/provider_appstatus.dart';
import 'package:playinsample/providers/provider_exam.dart';
import 'package:playinsample/screens/screen_profileset.dart';
import 'package:playinsample/screens/screen_questionpages.dart';
import 'package:provider/provider.dart';



class ScreenSelect extends StatelessWidget {

  ProviderExam _providerExam;
  ProviderAppStatus _providerAppStatus;

  PageController _pageController;

  @override
  Widget build(BuildContext context) {
    print('ScreenSelect : 빌드 새로고침');



    _providerExam = Provider.of<ProviderExam>(context,listen: false);

    _providerExam.setOnlineList();
    _providerExam.setOfflineList();

    _providerAppStatus = Provider.of<ProviderAppStatus>(context,listen: true);

    _pageController = PageController(initialPage: _providerExam.getBottomBarPage(),);


    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: color_charcoal_blue,
          child: Icon(Icons.cloud_download_rounded),
        ),

        bottomNavigationBar:

        Consumer<ProviderExam>(
          builder: (context,provider,child){
            return  BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: color_charcoal_blue,
              currentIndex: provider.getBottomBarPage(),
              onTap: (index){
                if(index>_providerExam.getBottomBarPage()){
                  _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.decelerate);
                }else if(index<_providerExam.getBottomBarPage()){
                  _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.decelerate);
                }
                _providerExam.setBottomBarPage(index);

              },
              items: [
                BottomNavigationBarItem(
                    title: Text('온라인 검사'),
                    icon: Icon(Icons.online_prediction_outlined)),
                BottomNavigationBarItem(
                    title: Text('오프라인 검사'),
                    icon: Icon(Icons.all_inbox_sharp)),
              ],
            );
          },
        ),
        backgroundColor: color_silver_white,
        appBar: AppBar(
          title: Text(
            'Sample for Playin!',
            style: TextStyle(fontWeight: FontWeight.w300,color: Colors.white),
          ),
          backgroundColor: color_charcoal_blue,
          elevation: 0,
          actions: [
            IconButton(
                icon: Icon(Icons.settings,color: Colors.white,),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ScreenProfileSet();
                  }));
                })
          ],
        ),
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
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
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
                      FutureBuilder<String>(
                        future: _providerAppStatus.getUserStatus(),
                        builder: (context,snapshot){
                          if(!snapshot.hasData)
                            return Container();

                          return Text(
                            snapshot.data,
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

              PageView(
                onPageChanged: (index){
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
                        ModelExam modelExam = _providerExam.getOnlineList()[index];

                        return _listItem(context, modelExam);
                      }),
                  ListView.builder(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      itemCount: _providerExam.getOfflineList().length,
                      itemBuilder: (context, index) {
                        ModelExam modelExam = _providerExam.getOfflineList()[index];

                        return _listItem(context, modelExam);
                      }),
                ],
              ),
            ),
          ],
        ));
  }



  Widget _listItem(BuildContext context, ModelExam modelExam) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child:

          RaisedButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return ScreenQuestionPages(modelExam,_providerExam.getBottomBarPage()==0?true:false);
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
