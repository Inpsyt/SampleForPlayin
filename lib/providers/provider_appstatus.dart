

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderAppStatus extends ChangeNotifier{

  String userStatus;

  Future<String> getUserStatus() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    userStatus = prefs.getString('userStatus')?? '이름없음';

    return this.userStatus;
  }

  setUserStatus(String userStatus) async{
    this.userStatus = userStatus;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userStatus', userStatus);
    notifyListeners();
  }


}