import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traffic_pro/ui/Home/home_screen.dart';

import '../core/utils/common_functions.dart';
import '../core/utils/functions.dart';
import 'Home/home_2_test.dart';
import 'Home/homescreen.dart';
import 'auth/login/login_view.dart';
import 'auth/onBoarding/onboard.dart';

// This class checks if user is start the app for 1st time or not, also checks if user was already logged in or not.
// and then gos to new screen based on that.

// We get users location on this screen.
class SplashServices{

  void isLogin(BuildContext context)async{

    //We share important info in sharedPreferences. It is saving data in local storage.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? onboard = prefs.getBool('onBoarded');
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    // here we fetch the users location
    var location = await CommonFunctions.getUserCurrentLocation();
    LatLng userLocation = LatLng(location.latitude, location.longitude);
    await deleteMarkersIfNeeded();


    //this if checks if user is starting the app for 1st time or not
    if(onboard == true ){

      //if checks if user was already logged in to firebase or not
      if (user != null){
        Timer(const Duration(seconds: 1), () =>
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreenView(userLocation: userLocation ))));

      }
      //else takes the user to login screen
      else{

        Timer(const Duration(seconds: 3), () =>
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginView())));

      }
      //this else takes the user to onBoarding screen where we get the details screen of app.
    }else{
      Timer(const Duration(seconds: 3), () =>
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> OnBoardingScreen())));

    }


  }


}