import 'package:flutter/material.dart';
import 'package:playinsample/constants/constant_colors.dart';

class ScreenProfileSet extends StatefulWidget {
  @override
  _ScreenProfileSetState createState() => _ScreenProfileSetState();
}

class _ScreenProfileSetState extends State<ScreenProfileSet> {

  TextEditingController textController = new TextEditingController();



  @override
  Widget build(BuildContext context) {

    textController.text = '김남철';

    return Scaffold(
      backgroundColor: color_charcoal_purple,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color_charcoal_purple,
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
                  width: 100,
                  child: TextField(

                    textAlign: TextAlign.center,
                    controller: textController,

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
