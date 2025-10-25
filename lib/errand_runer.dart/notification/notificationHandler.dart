import 'package:flutter/material.dart';

class HandlerOfNotificate {
  static final HandlerOfNotificate _singleton = HandlerOfNotificate._internal();

  factory HandlerOfNotificate() {
    return _singleton;
  }

  HandlerOfNotificate._internal() {}
}
