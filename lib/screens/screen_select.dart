import 'package:flutter/material.dart';
import 'package:playinsample/constants/constant_colors.dart';
import 'package:playinsample/models/model_exam.dart';
import 'package:playinsample/providers/provider_exam.dart';
import 'package:playinsample/screens/screen_profileset.dart';
import 'package:playinsample/screens/screen_questionpages.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';



class ScreenSelect extends StatelessWidget {

  ProviderExam _providerExam;

  @override
  Widget build(BuildContext context) {



    _providerExam = Provider.of<ProviderExam>(context,listen: false);
    _providerExam.initList();
    _providerExam.addList();

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: color_charcoal_blue,
          child: Icon(Icons.cloud_download_rounded),
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
                height: screenSize.height / 3.5,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                        offset: Offset(0.1, 0.9))
                  ],
                  color: color_charcoal_blue,
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
                      Text(
                        '김남철',
                        style: TextStyle(color: Colors.white, fontSize: 23),
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
              child: ListView.builder(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  itemCount: _providerExam.getList().length,
                  itemBuilder: (context, index) {
                    ModelExam modelExam = _providerExam.getList()[index];

                    return _listItem(context, modelExam);
                  }),
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
            return ScreenQuestionPages(modelExam.body, modelExam.name);
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
