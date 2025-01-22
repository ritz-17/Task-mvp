import 'dart:async';
import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  int _totalDuration = 100; // Total duration in seconds
  int _elapsedTime = 0; // Elapsed time in seconds
  Timer? _timer;

  int get remainingTime => _totalDuration - _elapsedTime;
  double get progress => remainingTime / _totalDuration;
  bool get isRunning => _timer != null;

  void startTimer(int duration) {
    if (_timer != null) return;

    _totalDuration = duration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_elapsedTime < _totalDuration) {
        _elapsedTime++;
        notifyListeners();
      } else {
        stopTimer();
      }
    });

    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  void resetTimer(int duration) {
    stopTimer();
    _totalDuration = duration;
    _elapsedTime = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
