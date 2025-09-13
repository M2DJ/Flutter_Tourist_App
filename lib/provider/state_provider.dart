import 'package:flutter/material.dart';

class StateProvider extends ChangeNotifier {
  late String _state;

  set theState(String value) {
    _state = value;
  }

  String get state => _state;
}
