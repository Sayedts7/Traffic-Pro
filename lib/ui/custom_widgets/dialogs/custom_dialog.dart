import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traffic_pro/ui/Home/homescreen.dart';

import '../../../core/providers/loading_provider.dart';
import '../../Home/home_2_test.dart';

Future<void> showDeleteDialog(BuildContext context, String message, String id, String userId, int deleteCount, LatLng location, bool myMarkers ) async {
  var uId = FirebaseAuth.instance.currentUser!.uid;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Marker', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if(userId == uId){
                FirebaseFirestore.instance.collection('markers').doc(id).delete();
                if(myMarkers){
                  Navigator.pop(context);
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen(userLocation:location )));
                }else{
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen(userLocation:location )));
                }
              }else{
                FirebaseFirestore.instance.collection('markers').doc(id).update({
                  "deleteCount": deleteCount+1,
                });
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen(userLocation:location )));


              }

            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () {
              // final loadingProvider =
              // Provider.of<LoadingProvider>(context, listen: false);
              // loadingProvider.loginLoading(false);


              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}
