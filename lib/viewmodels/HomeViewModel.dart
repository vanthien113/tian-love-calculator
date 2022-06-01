import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:love_calculator/models/entities/ResponseEntity.dart';
import 'package:love_calculator/models/repository/CalculatorRepository.dart';

mixin HomeViewEvent {
  void showResultDialog(ResponseEntity result);

  void changeLoadingState(bool isLoading);
}

enum ValidateName { INVALID_YOUR_NAME, INVALID_YOUR_FRIEND_NAME }

class HomeViewModel extends ChangeNotifier {
  final CalculatorRepository _calculatorRepository = CalculatorRepository();

  final _getPercentageBroadcast = StreamController.broadcast();
  final _loadingBroadcast = StreamController.broadcast();
  final _errorBroadcast = StreamController.broadcast();
  final _invalidNameBroadcast = StreamController.broadcast();

  Stream getPercentageStream() => _getPercentageBroadcast.stream;

  Stream getLoadingStream() => _loadingBroadcast.stream;

  Stream errorStream() => _errorBroadcast.stream;

  Stream invalidNameStream() => _invalidNameBroadcast.stream;
  ResponseEntity responseEntityObs = ResponseEntity();

  bool validateInput(String yourName, String yourFriendName) {
    if (yourName.isEmpty) {
      _invalidNameBroadcast.add(ValidateName.INVALID_YOUR_NAME);
      return false;
    }
    if (yourFriendName.isEmpty) {
      _invalidNameBroadcast.add(ValidateName.INVALID_YOUR_FRIEND_NAME);
      return false;
    }
    return true;
  }

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
