

import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:traffic_pro/core/utils/theme_helper.dart';

import 'mySize.dart';

class CommonFunctions {
  static String? validateTextField(value) {
    if (value == null || value.isEmpty) {
      return "Field is Requireed";
    } else {
      return null;
    }
  }

  static void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static flushBarErrorMessage(String msg, BuildContext context) {
    MySize().init(context);
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        message: msg,
        barBlur: 2,
        messageColor: ThemeColors.fillColor,
        messageSize: MySize.size12,
        backgroundColor: ThemeColors.red,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        duration: const Duration(seconds: 3),
        borderColor: ThemeColors.red,
        borderWidth: 0.1,
        positionOffset: 20,
        icon: Icon(
          Icons.error,
          size: MySize.size26,
          color: ThemeColors.fillColor,
        ),
        borderRadius: BorderRadius.circular(5),
      )..show(context),
    );
  }

  static flushBarSuccessMessage(String msg, BuildContext context) {
    MySize().init(context);
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        message: msg,
        barBlur: 2,
        messageColor: ThemeColors.fillColor,
        messageSize: MySize.size12,
        backgroundColor: Colors.green,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        duration: const Duration(seconds: 3),
        borderColor: Colors.green,
        borderWidth: 0.1,
        positionOffset: 20,
        icon: Icon(
          Icons.check_circle_rounded,
          size: MySize.size26,
          color: ThemeColors.fillColor,
        ),
        borderRadius: BorderRadius.circular(5),
      )..show(context),
    );
  }
 static Future<Position> getUserCurrentLocation() async{
    // print('object1');
    await Geolocator.requestPermission().then((value) {
      print(value);

    }).onError((error, stackTrace) {
      // print('error');
    });
    // print(Geolocator.getCurrentPosition());
    Position position = await Geolocator.getCurrentPosition();
    // print(position);

    return position;
  }
  static Future<bool> checkInternetConnection() async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    return isConnected;
  }
  static void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:  Text('No Internet'),
        content:
        Text('Please check your internet connection again'),
        actions: [
          ElevatedButton(
            child:  Text('Ok'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
  static void loginFailedDialog(BuildContext context, String error, VoidCallback onTap){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('Sign in failed'),
          content: Text(error),
          actions: [
            TextButton(
              child:  Text('Ok'),
              onPressed: onTap,
            ),
          ],
        );
      },
    );
  }
  static void authErrorSnackbar(BuildContext context, String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black.withOpacity(0.6),
        // margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        // elevation: 20,
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Add any action on pressing the close button
          },
        ),
      ),
    );
  }


}
