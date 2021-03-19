

import 'package:flutter/cupertino.dart';

class ProviderQuestionPages extends ChangeNotifier{







  int _scrollPosition = -1;
  int getScrollPosition() => this._scrollPosition;
  void setScrollPosition(int position) {
    this._scrollPosition = position;
    notifyListeners();
  }

  int _dynamicDuration = 1000;
  int getDynamicDuration() => this._dynamicDuration;
  void setDynamicDuration(int duration) {
    this._dynamicDuration = duration;
    notifyListeners();
  }

  double _floatingCircleSize = 180;
  double getFloatingCircleSize() => this._floatingCircleSize;
  void setFloatingCircleSize(double size){
    this._floatingCircleSize = size;
    notifyListeners();
  }


  int _floatingCircleChildText = 1;
  int getFloatingCircleChildText()  => this._floatingCircleChildText;
  void setFloatingCircleChildText(int num) {
    this._floatingCircleChildText = num;
    notifyListeners();
  }

  double _soundLevel = 0.0;
  double getSoundLevel() => this._soundLevel;
  void setSoundLevel(double level) {
    this._soundLevel = level;
    notifyListeners();
  }

}