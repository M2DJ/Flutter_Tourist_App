import 'package:flutter/material.dart';

class StateProvider extends ChangeNotifier {
  String _selectedState = '';

  StateProvider() : _selectedState = '';

  void choosingState(String value) {
    _selectedState = value;
    notifyListeners();
  }

  String get getState => _selectedState;
  
}
