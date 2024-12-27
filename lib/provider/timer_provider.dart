import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  bool _isTimerStarted = false;

  bool get isTimerStarted => _isTimerStarted;

  void startTimer() {
    _isTimerStarted = true;
    notifyListeners();
  }

  void stopTimer() {
    _isTimerStarted = false;
    notifyListeners();
  }
}