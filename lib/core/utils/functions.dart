import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


File? _image;

Future<void> getImage(LatLng position, String eventType) async {
  final imagePicker = ImagePicker();
  final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    _image = File(pickedFile.path);
    print('here in get image0000000000000000000');
    await addMarker(position, eventType);
    print('here in get image0000000000000000000 after addmerker');

  } else {
    print('No image selected.');
  }
}
Future<Marker> addMarker(LatLng position, String eventType) async {
  // Get the image
  print('here in get marker 1111111111111111111111111');

  // Upload the image to Firebase Storage
  String imageUrl = '';
  if (_image != null) {
    print('here in get image0000000000000000000 if 1');

    final Reference storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now().toString()}.jpg');
    final UploadTask uploadTask = storageRef.putFile(_image!);
    print(uploadTask.snapshot.bytesTransferred);

    // Wait for the upload task to complete
    await uploadTask;

    imageUrl = await storageRef.getDownloadURL();
    print('Image uploaded. Image URL: $imageUrl');
  }

  // Add marker to the map
  Marker marker = Marker(
    markerId: MarkerId(position.toString()),
    position: position,
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    infoWindow: InfoWindow(title: eventType),
  );

  // Save marker data to Firestore
  await FirebaseFirestore.instance.collection('markers').add({
    'latitude': position.latitude,
    'longitude': position.longitude,
    'eventType': eventType,
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'createdAt': DateTime.now(),
    'imageUrl': imageUrl,
    'deleteCount': 0,
  });

  // Reset the image file
  _image = null;

  return marker;
}


//check and delete fake marker
Future<void> deleteMarkersIfNeeded() async {
  // Get the current time
  DateTime currentTime = DateTime.now();

  // Query the markers collection
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('markers').get();

  // Iterate over the documents in the query snapshot
  for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
    Map<String, dynamic> data = documentSnapshot.data();
    if (data['createdAt'] != null && currentTime.difference(data['createdAt'].toDate()).inMinutes > 30) {
      // Delete the marker
      await FirebaseFirestore.instance.collection('markers').doc(documentSnapshot.id).delete();
    }else{
      if (data['deleteCount'] != null && data['deleteCount'] >= 3) {
        // Delete the marker
        await FirebaseFirestore.instance.collection('markers').doc(documentSnapshot.id).delete();
      }

    }
    // Check if the delete count is equal to or greater than 3
  }
}

