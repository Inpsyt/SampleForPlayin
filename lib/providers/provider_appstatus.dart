

import 'package:flutter/cupertino.dart';
import 'package:playinsample/models/model_userInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderAppStatus extends ChangeNotifier{

  ModelUserInfo _userInfo;


  Future<ModelUserInfo> getUserInfo() async{
    _userInfo = ModelUserInfo();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    _userInfo.testerName = prefs.getString('testerName')?? '이름없음';
    _userInfo.groupName = prefs.getString('groupName')??'서비스기획팀';

    return this._userInfo;
  }

  setUserInfo(ModelUserInfo userInfo) async{

    this._userInfo = userInfo;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('testerName', _userInfo.testerName);
    prefs.setString('groupName', _userInfo.groupName);
    notifyListeners();
  }


}