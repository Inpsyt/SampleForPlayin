

import 'package:flutter/cupertino.dart';

class ProviderScrollAnimation extends ChangeNotifier{

  int _scrollPosition = -1;
  int _dynamicDuration = 1000;

  int getScrollPosition() => this._scrollPosition;

  void setScrollPosition(int position) {
    this._scrollPosition = position;
    notifyListeners();
  }


  int getDynamicDuration() => this._dynamicDuration;
  void setDynamicDuration(int duration) {
    this._dynamicDuration = duration;
    notifyListeners();
  }

}