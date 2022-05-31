import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:love_calculator/models/entities/ResponseEntity.dart';
import 'package:love_calculator/models/repository/CalculatorRepository.dart';

mixin HomeViewEvent {
  void showResultDialog(ResponseEntity result);

  void changeLoadingState(bool isLoading);
}

class HomeViewModel extends ChangeNotifier {
  final CalculatorRepository _calculatorRepository = CalculatorRepository();

  final _getPercentageBroadcast = StreamController.broadcast();

  Stream getPercentageStream() => _getPercentageBroadcast.stream;

  final _loadingBroadcast = StreamController.broadcast();

  Stream getLoadingStream() => _loadingBroadcast.stream;

  final _errorBroadcast = StreamController.broadcast();

  Stream errorStream() => _errorBroadcast.stream;

  ResponseEntity responseEntityObs = ResponseEntity();

  void getPercentage(String yourName, String friendName) {
    _loadingBroadcast.add(true);
    _calculatorRepository.calculate(yourName, friendName).then((value) {
      _loadingBroadcast.add(false);
      _getPercentageBroadcast.add(value);
    }).catchError((onError) {
      _loadingBroadcast.add(false);
      _errorBroadcast.add(onError.toString());
    });
  }
}
