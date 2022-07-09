import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// WePeiYangApp统一使用的toast，共有三种类型
class ToastProvider {
  static success(
      String msg, {
        ToastGravity gravity = ToastGravity.BOTTOM,
        Color backgroundColor = Colors.green,
        Color textColor = Colors.white,
      }) {
    print('ToastProvider success: $msg');
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: backgroundColor,
        gravity: gravity,
        textColor: textColor,
        fontSize: 15.0);
  }

  static error(String msg, {ToastGravity gravity = ToastGravity.BOTTOM}) {
    print('ToastProvider error: $msg');
    Fluttertoast.showToast(
        msg: msg,
        backgroundColor: const Color.fromRGBO(53, 53, 53, 1),
        gravity: gravity,
        textColor: Colors.white,
        fontSize: 15.0);
  }

  static running(String msg, {ToastGravity gravity = ToastGravity.BOTTOM}) {
    print('ToastProvider running: $msg');
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 15.0,
      gravity: gravity,
    );
  }
}
