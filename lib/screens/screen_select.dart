import 'package:flutter/material.dart';
import 'package:playinsample/constants/constant_colors.dart';
import 'package:playinsample/screens/screen_profileset.dart';
import 'package:playinsample/screens/screen_questionpages.dart';

class ModelExam {
  final String name;
  final body;

  ModelExam(this.name, this.body);
}

class ScreenSelect extends StatelessWidget {
  List<ModelExam> list = List<ModelExam>();

  void _addList() {
    ModelExam modelExam;

    modelExam = new ModelExam('CST 성격강점검사 문항', {
      "key":
          "김철수C|M|20000101|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트|| | |CST_CO_SG|MEM00000000000050182|심리검사센터|",
    });
    list.add(modelExam);

    modelExam = new ModelExam('NEO2(초등용) 문항', {
      "key":
          "김철수N|M|20100624|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트||AT_S_0004|2028|NEO2_CO_SG_E|MEM00000000000050182|심리검사센터|",
    });
    list.add(modelExam);

    modelExam = new ModelExam('NEO2(청소용) 문항', {
      "key":
          "김철수N|M|20040102|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트||AT_S_0005|2044|NEO2_CO_SG_A|MEM00000000000050182|심리검사센터|",
    });
    list.add(modelExam);

    modelExam = new ModelExam('NEO2(대학/성인용) 문항', {
      "key":
          "김철수N|M|19880102|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트|| | |NEO2_CO_SG_COL|MEM00000000000050182|심리검사센터|",
    });
    list.add(modelExam);

    modelExam = new ModelExam('PAI 성격평가질문지_일반[증보판] 문항', {
      "key":
          "김철수PA|M|20000505|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트||AT_S_0001|2000|PAIR_CO_SG|MEM00000000000050182|심리검사센터|",
      "addInquiry": "자영업|미혼"
    });
    list.add(modelExam);

    modelExam = new ModelExam('Hollan 직업적성검사(대학/성인) 문항', {
      "key":
          "김철수H|M|20000101|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트||AT_S_0007|2062|HollandVPI_CO_SG_COL|MEM00000000000050182|심리검사센터|",
    });
    list.add(modelExam);

    modelExam = new ModelExam('KIIP 한국형 대인관계검사 문항', {
      "key":
          "김철수KP|M|20000101|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트|| | |KIIP_CO_SG|MEM00000000000050182|심리검사센터|",
    });
    list.add(modelExam);

    modelExam = new ModelExam('IESS 통합스트레스검사 문항', {
      "key":
          "김철수I|M|20000101|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트|| | |IESS_CO_SG|MEM00000000000050182|심리검사센터|",
    });
    list.add(modelExam);

    modelExam = new ModelExam('MLST-II 학습전략검사(초등용) 문항', {
      "key":
          "김철수M|M|20080101|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트||AT_S_0004|2028|MLST2_CO_SG_E|MEM00000000000050182|심리검사센터|",
    });
    list.add(modelExam);

    modelExam = new ModelExam('MLST-II 학습전략검사(대학생용) 문항', {
      "key":
          "김철수M|M|19880101|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트||AT_S_0007|2060|MLST2_CO_SG_COL|MEM00000000000050182|심리검사센터|",
    });
    list.add(modelExam);

    modelExam = new ModelExam('MLST-II 학습전략검사(청소년용) 문항', {
      "key":
          "김철수M|M|20040101|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트||AT_S_0006|2052|MLST2_CO_SG_A|MEM00000000000050182|심리검사센터|",
    });
    list.add(modelExam);

    modelExam = new ModelExam('KPSI4 한국판 부모 양육스트레스 검사 문항', {
      "key":
          "김철수KI|M|20000101|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트|| | |KPSI4_CO_PG|MEM00000000000050182|심리검사센터|",
      "addInquiry": "미혼|부|김자녀|여|만 4세"
    });
    list.add(modelExam);

    modelExam = new ModelExam('PCT 부모양육특성 검사 문항', {
      "key":
          "김철수P|M|20020125|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트|| | |PCT_CO_PG|MEM00000000000050182|심리검사센터|",
      "addInquiry":
          "아동의 발달문제|연락처 및 이메일|작성자 이름|아동과의 관계|부 연령|부 직업|모 연령|모 직업|부 학력|모 학력"
    });
    list.add(modelExam);

    modelExam = new ModelExam('KPRQ 아동청소년용 부모자녀관계검사 문항', {
      "key":
          "김철수KQ|M|20040125|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트||AT_S_0006|2050|KPRQ_CO_PG_CA|MEM00000000000050182|심리검사센터|",
      "addInquiry": "김철수KQ|부"
    });
    list.add(modelExam);

    modelExam = new ModelExam('KPRQ 유아용 부모자녀관계검사 문항', {
      "key":
          "김철수KQ|M|20180103|010-1234-1234|xodyd2425@hakjisa.co.kr|인싸이트|| | |KPRQ_CO_PG_P|MEM00000000000050182|심리검사센터|",
      "addInquiry": "김철수KQ|부"
    });
    list.add(modelExam);
  }

  @override
  Widget build(BuildContext context) {
    _addList();

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: color_charcoal_purple,
          child: Icon(Icons.cloud_download_rounded),
        ),
        backgroundColor: color_silver_white,
        appBar: AppBar(
          title: Text(
            'Sample for Playin!',
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
          backgroundColor: color_charcoal_purple,
          elevation: 0,
          actions: [
            IconButton(
                icon: Icon(Icons.settings),
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
                  color: color_charcoal_purple,
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
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    ModelExam modelExam = list[index];

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

          /*NeumorphicButton(
          margin: EdgeInsets.only(top: 12),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return ScreenQuestionPages(modelExam.body, modelExam.name);
            }));
          },
          style: NeumorphicStyle(
            color: color_silver_white,
            shadowLightColor: Colors.white,
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
            //border: NeumorphicBorder()
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Text(
            modelExam.name,
            style: TextStyle(color: color_dark_black, fontSize: 17),
          )),

       */

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
