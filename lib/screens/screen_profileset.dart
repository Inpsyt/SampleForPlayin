import 'package:flutter/material.dart';
import 'package:playinsample/constants/constant_colors.dart';
import 'package:playinsample/models/model_userInfo.dart';
import 'package:playinsample/providers/provider_appstatus.dart';
import 'package:provider/provider.dart';

class ScreenProfileSet extends StatefulWidget {
  @override
  _ScreenProfileSetState createState() => _ScreenProfileSetState();
}

class _ScreenProfileSetState extends State<ScreenProfileSet>
    with SingleTickerProviderStateMixin {
  ProviderAppStatus _providerAppStatus;
  TextEditingController controller = TextEditingController();
  ModelUserInfo _modelUserInfo;

  Animation _animation, _delayedAnimation, _muchDelayedAnimation;
  AnimationController _animationController;


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;

    _animationController =
        AnimationController(duration: Duration(seconds: 9), vsync: this);

    _animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    _delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    _delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));

    _providerAppStatus = Provider.of<ProviderAppStatus>(context, listen: false);

    _providerAppStatus.getUserInfo().then((value) {
      _modelUserInfo = value;
      controller.text = _modelUserInfo.testerName;
    });

    print('refreshed');

    return AnimatedBuilder(
      animation:_animationController,
      builder: (context,child){
        return Scaffold(
          backgroundColor: color_charcoal_blue,

          appBar: AppBar(
            leading: IconButton(icon: Icon(
              Icons.keyboard_arrow_left_outlined, color: Colors.white, size: 40,),
              onPressed: () {
                Navigator.pop(context);
              },),
            elevation: 0,
            backgroundColor: color_charcoal_blue,
            centerTitle: true,
            title: Text('프로필 설정', style: TextStyle(color: Colors.white),),
          ),
          body: Center(
            child: Container(
              width: screenSize.width / 1.3,
              height: screenSize.height / 1.8,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Colors.black54,
                        offset: Offset(0.1, 0.9),
                        blurRadius: 14)
                  ],
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Transform(
                      transform: Matrix4.translationValues(_animation.value*30, 0,0)
                      ,
                      child: Container(
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
                                  image: AssetImage('assets/images/profile.jpg')))),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 140,
                          child: TextField(
                            //이름 입력 영역
                            controller: controller,
                            textAlign: TextAlign.center,
                            onChanged: (text) async {
                              _modelUserInfo.testerName = text;
                              _modelUserInfo.groupName = '서비스기획팀';
                              _providerAppStatus.setUserInfo(_modelUserInfo);
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(hintText: '이름을 입력하세요..'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      '(대학생) 만 23세',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

}



