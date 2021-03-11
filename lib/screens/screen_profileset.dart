import 'package:flutter/material.dart';
import 'package:playinsample/constants/constant_colors.dart';
import 'package:playinsample/providers/provider_appstatus.dart';
import 'package:provider/provider.dart';

class ScreenProfileSet extends StatefulWidget {
  @override
  _ScreenProfileSetState createState() => _ScreenProfileSetState();
}


class _ScreenProfileSetState extends State<ScreenProfileSet> {

  ProviderAppStatus _providerAppStatus;
  TextEditingController controller = TextEditingController();



  @override
  Widget build(BuildContext context) {

    _providerAppStatus = Provider.of<ProviderAppStatus>(context,listen: false);

    controller.text = _providerAppStatus.userStatus;

    print('refreshed');


    return Scaffold(
      backgroundColor: color_charcoal_blue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color_charcoal_blue,
        centerTitle: true,
        title: Text('프로필 설정'),
      ),
      body: Center(
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
                        image: AssetImage('assets/images/profile.jpg')))),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [


                SizedBox(
                  width: 140,
                  child: TextField( //이름 입력 영역
                    controller: controller,
                    textAlign: TextAlign.center,
                    onChanged: (text)async {
                      _providerAppStatus.setUserStatus(text);
                    },
                    style: TextStyle(color: Colors.white),
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
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w300),
            )
          ],
        ),
      ),
    );
  }
}
