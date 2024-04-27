import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Marker> addMarker(LatLng position, String eventType) async {
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
  });

  return marker;
}