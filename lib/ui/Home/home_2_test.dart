// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_compass/flutter_compass.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:custom_info_window/custom_info_window.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:traffic_pro/providers/event_provider.dart';
// import 'package:traffic_pro/ui/auth/auth_controller.dart';
// import 'package:traffic_pro/ui/custom_widgets/dialogs/custom_dialog.dart';
// import 'dart:math' as math;
//
// import '../../core/services/Maps functions.dart';
// import '../../core/utils/functions.dart';
// import '../../core/utils/image_paths.dart';
// import '../../core/utils/mySize.dart';
// import '../../core/utils/theme_helper.dart';
// import '../custom_widgets/full_screen_image.dart';
//
// import 'dart:convert';
//
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
//
// import 'dart:math' show cos, sqrt, asin;
//
// import 'drawer.dart';
//
//
//
// class HomeScreen extends StatefulWidget {
//   final LatLng userLocation;
//   const HomeScreen({super.key, required this.userLocation});
//
//   @override
//   State<HomeScreen> createState() => HomeScreenState();
// }
//
// class HomeScreenState extends State<HomeScreen> {
//   bool search = false;
//
//   // from test class
//   late GoogleMapController mapController;
//   final CustomInfoWindowController _customInfoWindowController =
//   CustomInfoWindowController();
//
//   late Position _currentPosition;
//   String _currentAddress = '';
//
//   final startAddressController = TextEditingController();
//   final destinationAddressController = TextEditingController();
//
//   final startAddressFocusNode = FocusNode();
//   final desrinationAddressFocusNode = FocusNode();
//
//   String _startAddress = '';
//   String _destinationAddress = '';
//   String? _placeDistance;
//   // Set<Marker> markers = {};
//
//   late PolylinePoints polylinePoints;
//   Map<PolylineId, Polyline> polylines = {};
//   List<LatLng> polylineCoordinates = [];
//
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//
//
//
//   _getCurrentLocation() async {
//     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//         .then((Position position) async {
//       setState(() {
//         _currentPosition = position;
//         print('CURRENT POS: $_currentPosition');
//         mapController.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: LatLng(position.latitude, position.longitude),
//               zoom: 18.0,
//             ),
//           ),
//         );
//       });
//       await _getAddress();
//     }).catchError((e) {
//       print(e);
//     });
//   }
//   _getAddress() async {
//     print('this is caalled');
//     try {
//       List<Placemark> p = await placemarkFromCoordinates(
//           _currentPosition.latitude, _currentPosition.longitude);
//
//       Placemark place = p[0];
//       print(place);
//
//       setState(() {
//         _currentAddress =
//         "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
//         startAddressController.text = _currentAddress;
//         _startAddress = _currentAddress;
//       });
//       print('this is caalled $_currentAddress');
//
//     } catch (e) {
//       print('this is caalled here o n catch error $e');
//
//       print(e);
//     }
//   }
//
//
//   // Method for retrieving the current location
//   String distanceText = '';
//   String travelTimeText = '';
//
// // this function needs to be commented.
//   Future<void> calculateDistanceAndTime() async {
//
//     final url =
//         'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$_startAddress&destinations=$_destinationAddress&mode=driving&key=AIzaSyCUO40W_nDrilaL-2ny5RcWYpzHdlNil-M';
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       final elements = data['rows'][0]['elements'];
//       final distance = elements[0]['distance']['value'];
//       final duration = elements[0]['duration']['value'];
//
//       setState(() {
//         distanceText = '${distance / 1000} km';
//         travelTimeText = '${Duration(seconds: duration).inMinutes} mins';
//       });
//
//       // Check for markers along the route (implementation details omitted for brevity)
//     } else {
//       // Handle API errors
//     }
//   }
//
//
//   // Method for retrieving the address
//
//
//   // Method for calculating the distance between two places
//   Future<bool> _calculateDistance() async {
//     try {
//       print(_currentAddress);
//       print('111111111111111111111111');
//       print('this is $_startAddress');
//
//
//       // Retrieving placemarks from addresses
//       List<Location>? startPlacemark = await locationFromAddress(_startAddress);
//       List<Location>? destinationPlacemark =
//       await locationFromAddress(_destinationAddress);
//       print(startPlacemark);
//       print(destinationPlacemark);
//
//       // Use the retrieved coordinates of the current position,
//       // instead of the address if the start position is user's
//       // current position, as it results in better accuracy.
//       double startLatitude = _startAddress == _currentAddress
//           ? _currentPosition.latitude
//           : startPlacemark[0].latitude;
//
//       double startLongitude = _startAddress == _currentAddress
//           ? _currentPosition.longitude
//           : startPlacemark[0].longitude;
//
//       double destinationLatitude = destinationPlacemark[0].latitude;
//       double destinationLongitude = destinationPlacemark[0].longitude;
//
//       String startCoordinatesString = '($startLatitude, $startLongitude)';
//       String destinationCoordinatesString =
//           '($destinationLatitude, $destinationLongitude)';
//
//       // Start Location Marker
//       Marker startMarker = Marker(
//         markerId: MarkerId(startCoordinatesString),
//         position: LatLng(startLatitude, startLongitude),
//         infoWindow: InfoWindow(
//           title: 'Start $startCoordinatesString',
//           snippet: _startAddress,
//         ),
//         icon: BitmapDescriptor.defaultMarker,
//       );
//
//       // Destination Location Marker
//       Marker destinationMarker = Marker(
//         markerId: MarkerId(destinationCoordinatesString),
//         position: LatLng(destinationLatitude, destinationLongitude),
//         infoWindow: InfoWindow(
//           title: 'Destination $destinationCoordinatesString',
//           snippet: _destinationAddress,
//         ),
//         icon: BitmapDescriptor.defaultMarker,
//       );
//
//       // Adding the markers to the list
//       _marker.add(startMarker);
//       _marker.add(destinationMarker);
//
//       print(
//         'START COORDINATES: ($startLatitude, $startLongitude)',
//       );
//       print(
//         'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
//       );
//
//       // Calculating to check that the position relative
//       // to the frame, and pan & zoom the camera accordingly.
//       double miny = (startLatitude <= destinationLatitude)
//           ? startLatitude
//           : destinationLatitude;
//       double minx = (startLongitude <= destinationLongitude)
//           ? startLongitude
//           : destinationLongitude;
//       double maxy = (startLatitude <= destinationLatitude)
//           ? destinationLatitude
//           : startLatitude;
//       double maxx = (startLongitude <= destinationLongitude)
//           ? destinationLongitude
//           : startLongitude;
//
//       double southWestLatitude = miny;
//       double southWestLongitude = minx;
//
//       double northEastLatitude = maxy;
//       double northEastLongitude = maxx;
//
//       // Accommodate the two locations within the
//       // camera view of the map
//       mapController.animateCamera(
//         CameraUpdate.newLatLngBounds(
//           LatLngBounds(
//             northeast: LatLng(northEastLatitude, northEastLongitude),
//             southwest: LatLng(southWestLatitude, southWestLongitude),
//           ),
//           100.0,
//         ),
//       );
//
//       // Calculating the distance between the start and the end positions
//       // with a straight path, without considering any route
//       // double distanceInMeters = await Geolocator().bearingBetween(
//       //   startCoordinates.latitude,
//       //   startCoordinates.longitude,
//       //   destinationCoordinates.latitude,
//       //   destinationCoordinates.longitude,
//       // );
//
//       await _createPolylines(startLatitude, startLongitude, destinationLatitude,
//           destinationLongitude);
//
//       double totalDistance = 0.0;
//
//       // Calculating the total distance by adding the distance
//       // between small segments
//       for (int i = 0; i < polylineCoordinates.length - 1; i++) {
//         totalDistance += _coordinateDistance(
//           polylineCoordinates[i].latitude,
//           polylineCoordinates[i].longitude,
//           polylineCoordinates[i + 1].latitude,
//           polylineCoordinates[i + 1].longitude,
//         );
//       }
//
//       setState(() {
//         _placeDistance = totalDistance.toStringAsFixed(2);
//         print('DISTANCE: $_placeDistance km');
//       });
//
//       return true;
//     } catch (e) {
//       print(e);
//     }
//     return false;
//   }
//
//   // Formula for calculating distance between two coordinates
//   // https://stackoverflow.com/a/54138876/11910277
//   double _coordinateDistance(lat1, lon1, lat2, lon2) {
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((lat2 - lat1) * p) / 2 +
//         c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
//     return 12742 * asin(sqrt(a));
//   }
//
//   // Create the polylines for showing the route between two places
//   _createPolylines(
//       double startLatitude,
//       double startLongitude,
//       double destinationLatitude,
//       double destinationLongitude,
//       ) async {
//     polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       'AIzaSyCUO40W_nDrilaL-2ny5RcWYpzHdlNil-M', // Google Maps API Key
//       PointLatLng(startLatitude, startLongitude),
//       PointLatLng(destinationLatitude, destinationLongitude),
//       travelMode: TravelMode.driving ,
//     );
//
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }
//
//     PolylineId id = const PolylineId('poly');
//     Polyline polyline = Polyline(
//       polylineId: id,
//       color: Colors.blue,
//       points: polylineCoordinates,
//       width: 3,
//     );
//     polylines[id] = polyline;
//   }
//
//   //////////////////////////////////////////////////
//   bool _hasPermissions = false;
//   AuthService authService = AuthService();
//   final Completer<GoogleMapController> _mapController =
//   Completer<GoogleMapController>();
//   final List<Marker> _marker = <Marker>[];
//
//
//
//   var _policeIcon;
//   var _roadBlockIcon;
//   var _carCrashIcon;
//   var _hazardIcon;
//   var _warningIco;
//   var _trafficIcon;
//
//   Future<void> _loadCustomIcons() async {
//     final List<String> iconPaths = [
//       icTraffic2,
//       icPolice2,
//       icCrash2,
//       icRoadBlock2,
//       vlc2,
//       icWarning2
//     ];
//
//     for (String path in iconPaths) {
//       final ByteData bytes = await rootBundle.load(path);
//       final Uint8List list = bytes.buffer.asUint8List();
//       final BitmapDescriptor icon = BitmapDescriptor.fromBytes(list,size: const Size(1,1));
//
//       if (path.contains('police')) {
//         _policeIcon = icon;
//       } else if (path.contains('road_block2')) {
//         _roadBlockIcon = icon;
//       } else if (path.contains('carCrash')) {
//         _carCrashIcon = icon;
//       }else if (path.contains('hazard')) {
//         _hazardIcon = icon;
//       }else if (path.contains('vlc')) {
//         _warningIco = icon;
//       }else if (path.contains('traffic')) {
//         _trafficIcon = icon;
//       }
//     }
//   }
//   final _sheet = GlobalKey();
//   final _controller = DraggableScrollableController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCustomIcons();
//     _getCurrentLocation();
//
//     // loadData2();
//     // loadData();
//
//     // getUserCurrentLocation();
//     _fetchPermissionStatus();
//
//     _controller.addListener(_onChanged);
//   }
//
//
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
//
//   DraggableScrollableSheet get sheet =>
//       (_sheet.currentWidget as DraggableScrollableSheet);
//
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//
//     // _marker.add(
//     //     Marker(
//     //   markerId: const MarkerId("user_location"),
//     //   position: widget.userLocation,
//     //   icon: BitmapDescriptor.defaultMarker,
//     //   infoWindow: const InfoWindow(title: "Your Location"),)
//     // );
//     final eventprovider = Provider.of<EventTypeProvider>(context, listen: false);
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: ThemeColors.black1,
//       // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       body: SafeArea(
//           child:StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance.collection('markers').snapshots(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return const CircularProgressIndicator();
//               }
//               snapshot.data!.docs.forEach((doc) {
//                 BitmapDescriptor icon;
//
//                 switch (doc['eventType']) {
//                   case 'Police':
//                     icon = _policeIcon;
//                     break;
//                   case 'Traffic':
//                     icon = _trafficIcon;
//                     break;
//                   case 'Car Crash':
//                     icon = _carCrashIcon;
//                     break;
//                   case 'Hazard':
//                     icon = _hazardIcon;
//                     break;
//                   case 'Warning':
//                     icon = _warningIco;
//                     break;
//                   case 'Block':
//                     icon = _roadBlockIcon;
//                     break;
//                   default:
//                     icon = BitmapDescriptor.defaultMarker;
//                 }
//
//                 // Add marker to the map
//                 Marker marker = Marker(
//
//                   markerId: MarkerId(doc.id),
//                   position: LatLng(doc['latitude'], doc['longitude']),
//                   icon: icon,
//                   onTap: () {
//                     print(doc['imageUrl']);
//                     print('0000000000000000000000000000000000000');
//                     _customInfoWindowController.addInfoWindow!(
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
//                         child: Container(
//
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color: ThemeColors.mainColor,
//                             ),
//                             child:                                   Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                                 children: [
//                                   InkWell(
//                                     onTap: (){
//                                       Navigator.push(context, MaterialPageRoute(builder: (context) =>
//                                           ImageFullscreen(imageUrl: doc['imageUrl'])));
//                                       // ImageFullscreen(
//                                       //   imageUrl: 'https://example.com/image.jpg', // Replace with your image URL
//                                       // );
//                                     },
//                                     child: Container(
//                                       height: MySize.size140,
//                                       width:MySize.size140,
//                                       clipBehavior: Clip.hardEdge,
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(15)
//                                       ),
//                                       child: Image.network(doc['imageUrl']),
//                                       // child: CachedNetworkImage(
//                                       //   imageUrl: doc['imageUrl'],
//                                       //   fit: BoxFit.cover,
//                                       //   placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
//                                       //   errorWidget: (context, url, error) => const Icon(Icons.error),)
//                                     ),
//                                   ),
//                                   // Hero(
//                                   //   tag: doc['imageUrl'],
//                                   //   child: Container(
//                                   //     width: 50,
//                                   //     height: 50,
//                                   //     decoration: BoxDecoration(
//                                   //       shape: BoxShape.circle,
//                                   //       image: DecorationImage(
//                                   //         image: NetworkImage(doc['imageUrl']),
//                                   //         fit: BoxFit.cover,
//                                   //       ),
//                                   //     ),
//                                   //   ),
//                                   // )
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                                     children: [
//                                       Text(doc['eventType'], style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: MySize.size12, fontWeight: FontWeight.w500
//                                       ),),
//
//                                       IconButton(onPressed: (){
//
//                                         showDeleteDialog(context, 'Are you sure you want to delete this',
//                                             doc.id, doc['userId'], doc['deleteCount'],
//                                             widget.userLocation, false).then((value) {
//                                           setState(() {
//
//                                           });
//                                         });
//
//                                       }, icon: Icon(Icons.delete,size: 20,))
//
//                                     ],
//                                   ),
//
//
//
//
//
//                                 ],
//                               ),
//                             )
//
//                         ),
//                       ),
//                       LatLng(doc['latitude'], doc['longitude']),
//                     );
//                   },
//                   // infoWindow: InfoWindow(title: doc['eventType']),
//
//                 );
//                 _marker.add(marker);
//               });
//               return  Stack(
//                 children: [
//                   GoogleMap
//                     (
//                     onTap:(position)async{
//                       _customInfoWindowController.hideInfoWindow!();
//
//                       if(eventprovider.event != ''){
//                         await getImage(position, eventprovider.event).then((value) {
//                           SnackBar(content: Text('added'));
//                         });
//
//                         // await addMarker(position, eventprovider.event);
//                         // _marker.add(mar);
//                         eventprovider.updateEvent('');
//                         setState(() {
//
//                         });
//                       }
//
//                     } ,
//                     trafficEnabled: true,
//                     zoomControlsEnabled: false,
//                     myLocationButtonEnabled: true,
//                     myLocationEnabled: true,
//                     // myLocationEnabled: true,
//                     mapType: MapType.normal,
//                     initialCameraPosition: CameraPosition(target: widget.userLocation, zoom: 14),
//                     polylines: Set<Polyline>.of(polylines.values),
//
//                     onMapCreated: (GoogleMapController controller) {
//                       print(snapshot.data!.docs.first['imageUrl']);
//                       mapController = controller;
//                       _customInfoWindowController.googleMapController = controller;
//
//                       // _mapController.complete(controller);
//                     },
//
//                     onCameraMove: (position) {
//                       _customInfoWindowController.onCameraMove!();
//                     },
//                     markers: Set<Marker>.of(_marker),
//
//
//                   ),
//                   CustomInfoWindow(
//                     controller: _customInfoWindowController,
//                     height: MySize.size250,
//                     width: MySize.size220,
//                     offset: 35,
//                   ),
//                   Visibility(
//                     visible: search == true,
//                     child: SafeArea(
//                       child: Align(
//                         alignment: Alignment.topCenter,
//                         child: Padding(
//                           padding: const EdgeInsets.only(top: 10.0),
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               color: Colors.white70,
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(20.0),
//                               ),
//                             ),
//                             width: width * 0.9,
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: <Widget>[
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const SizedBox(width: 20,),
//                                       const Text(
//                                         'Search Route',
//                                         style: TextStyle(fontSize: 20.0),
//                                       ),
//                                       IconButton(onPressed: (){
//                                         setState(() {
//                                           search = false;
//                                           print('this is close called in search $search');
//
//                                         });
//                                         // Navigator.push(context, MaterialPageRoute(builder: (context)=> MapView(userLocation: widget.userLocation,)));
//                                       }, icon: const Icon(Icons.close))
//                                     ],
//                                   ),
//                                   const SizedBox(height: 10),
//                                   textField(
//                                       label: 'Start',
//                                       hint: 'Choose starting point',
//                                       prefixIcon: const Icon(Icons.looks_one),
//                                       suffixIcon: IconButton(
//                                         icon: const Icon(Icons.my_location),
//                                         onPressed: ()async {
//                                           await _getAddress();
//                                           print(_currentAddress);
//                                           startAddressController.text = _currentAddress;
//                                           _startAddress = _currentAddress;
//                                           print(_currentAddress);
//                                           print('22222222222222${startAddressController.text}');
//                                           print(_startAddress);
//
//
//
//                                         },
//                                       ),
//                                       controller: startAddressController,
//                                       focusNode: startAddressFocusNode,
//                                       width: width,
//                                       locationCallback: (String value) {
//                                         setState(() {
//                                           _startAddress = value;
//                                         });
//                                       }),
//                                   const SizedBox(height: 10),
//                                   textField(
//                                       label: 'Destination',
//                                       hint: 'Choose destination',
//                                       prefixIcon: const Icon(Icons.looks_two),
//                                       controller: destinationAddressController,
//                                       focusNode: desrinationAddressFocusNode,
//                                       width: width,
//                                       locationCallback: (String value) {
//                                         setState(() {
//                                           _destinationAddress = value;
//                                         });
//                                       }),
//                                   const SizedBox(height: 10),
//                                   Padding(
//                                     padding: const EdgeInsets.all(15.0),
//                                     child: Row(
//                                       children: [
//                                         Visibility(
//                                           visible: _placeDistance == null ? false : true,
//                                           child: Text(
//                                             'DISTANCE: $_placeDistance km',
//                                             style: const TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                         Visibility(
//                                           visible: _placeDistance == null ? false : true,
//                                           child: Text(
//                                             //distanceText +' '+
//                                             ' | Time: $travelTimeText',
//                                             style: const TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const SizedBox(height: 5),
//                                   ElevatedButton(
//
//                                     onPressed: (_startAddress != '' &&
//                                         _destinationAddress != '')
//                                         ? () async {
//                                       calculateDistanceAndTime();
//                                       startAddressFocusNode.unfocus();
//                                       desrinationAddressFocusNode.unfocus();
//                                       setState(() {
//                                         if (_marker.isNotEmpty) _marker.clear();
//                                         if (polylines.isNotEmpty)
//                                           polylines.clear();
//                                         if (polylineCoordinates.isNotEmpty)
//                                           polylineCoordinates.clear();
//                                         _placeDistance = null;
//                                       });
//
//                                       _calculateDistance().then((isCalculated) {
//                                         if (isCalculated) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(
//                                             const SnackBar(
//                                               content: Text(
//                                                   'Distance Calculated Sucessfully'),
//                                             ),
//                                           );
//                                         } else {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(
//                                             const SnackBar(
//                                               content: Text(
//                                                   'Error Calculating Distance'),
//                                             ),
//                                           );
//                                         }
//                                       });
//                                     }
//                                         : null,
//                                     // color: Colors.red,
//                                     // shape: RoundedRectangleBorder(
//                                     //   borderRadius: BorderRadius.circular(20.0),
//                                     // ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Text(
//                                         'Show Route'.toUpperCase(),
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 20.0,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   Visibility(
//                     visible: search == false,
//                     child: Positioned(
//                         top: 10,
//                         left: 20,
//                         child: Container(
//                             height: 50,
//                             width: 50,
//                             decoration: BoxDecoration(
//                                 color: ThemeColors.black1,
//                                 borderRadius: BorderRadius.circular(10)
//                             ),
//                             child: IconButton(onPressed: (){
//                               getDrawer(context);
//                             }, icon: const Icon(Icons.menu, color: Colors.white,)))),
//                   ),
//                   Visibility(
//                     visible: search == false,
//                     child: Positioned(
//                         top: 10,
//                         right: 20,
//
//                         child: Container(
//                           height: 50,
//                           width: 50,
//                           decoration: BoxDecoration(
//                               color: ThemeColors.black1,
//                               borderRadius: BorderRadius.circular(10)
//                           ),
//                           child: IconButton(icon: const Icon(Icons.compass_calibration_outlined, color: ThemeColors.fillColor,),
//                             onPressed: (){
//                               // Navigator.push(context, MaterialPageRoute(builder: (context)=> MyApp()));
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return Dialog(
//                                     child: Container(
//                                       height: MySize.size320,
//                                       width: MySize.size350,
//                                       decoration: BoxDecoration(
//                                           color: ThemeColors.grey3,
//                                           borderRadius: BorderRadius.circular(20)
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(8.0),
//                                         child: Builder(builder: (context) {
//                                           if (_hasPermissions) {
//                                             return Column(
//                                               children: <Widget>[
//                                                 Expanded(child: _buildCompass()),
//                                               ],
//                                             );
//                                           } else {
//                                             return _buildPermissionSheet();
//                                           }
//                                         }),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//
//                             },),
//                         )),
//                   ),
//                   Visibility(
//                     visible: search == false,
//                     child: Positioned(
//                         bottom: 120,
//                         right: 20,
//
//                         child: Container(
//                           height: 50,
//                           width: 50,
//                           decoration: BoxDecoration(
//                               color: ThemeColors.black1,
//                               borderRadius: BorderRadius.circular(10)
//                           ),
//                           child: IconButton(icon:  const Icon(Icons.search, color: ThemeColors.fillColor,),
//                               onPressed: (){
//                                 setState(() {
//                                   search = true;
//                                 });
//                               }),
//                         )),
//                   ),
//                   Visibility(
//                     visible: search == false,
//                     child: Positioned(
//                         bottom: 20,
//                         right: 20,
//
//                         child: Container(
//                           height: 50,
//                           width: 50,
//                           decoration: BoxDecoration(
//                               color: ThemeColors.black1,
//                               borderRadius: BorderRadius.circular(10)
//                           ),
//                           child: IconButton(icon:  const Icon(Icons.warning, color: ThemeColors.fillColor,),
//                               onPressed: (){
//                                 getMapItems(context);
//                               }),
//                         )),
//                   ),
//                   Visibility(
//                     visible: search == false,
//                     child: Consumer<EventTypeProvider>(builder: (context, value,child){
//                       return   eventprovider.event == '' ? const SizedBox():
//                       Positioned(
//                           bottom: 20,
//                           left: 20,
//
//                           child: Container(
//                               height: 50,
//                               // width: 150,
//                               decoration: BoxDecoration(
//                                   color: ThemeColors.black1,
//                                   borderRadius: BorderRadius.circular(10)
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Center(child: Text('Click on map to add ${eventprovider.event}',style: const TextStyle(color: ThemeColors.fillColor),)),
//                               )
//                           ));
//                     }),
//                   )
//
//
//                 ],
//               );
//             },
//           )
//       ),
//     );
//   }
//   Widget _buildCompass() {
//     return StreamBuilder<CompassEvent>(
//       stream: FlutterCompass.events,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error reading heading: ${snapshot.error}');
//         }
//
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//
//         double? direction = snapshot.data!.heading;
//
//         // if direction is null, then device does not support this sensor
//         // show error message
//         if (direction == null)
//           return const Center(
//             child: Text("Device does not have sensors !"),
//           );
//
//         return Material(
//           shape: const CircleBorder(),
//           clipBehavior: Clip.antiAlias,
//           elevation: 4.0,
//           child: Container(
//             padding: const EdgeInsets.all(16.0),
//             alignment: Alignment.center,
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//             ),
//             child: Transform.rotate(
//               angle: (direction * (math.pi / 180) * -1),
//               child: SvgPicture.asset('assets/svgs/compass.svg'),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildPermissionSheet() {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           const Text('Location Permission Required'),
//           ElevatedButton(
//             child: const Text('Request Permissions'),
//             onPressed: () {
//               Permission.locationWhenInUse.request().then((ignored) {
//                 _fetchPermissionStatus();
//               });
//             },
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             child: const Text('Open App Settings'),
//             onPressed: () {
//               openAppSettings().then((opened) {
//                 //
//               });
//             },
//           )
//         ],
//       ),
//     );
//   }
//
//   void _fetchPermissionStatus() {
//     Permission.locationWhenInUse.status.then((status) {
//       if (mounted) {
//         setState(() => _hasPermissions = status == PermissionStatus.granted);
//       }
//     });
//   }
//
//   // Future<void> _goToTheLake() async {
//   //   final GoogleMapController controller = await _controller.future;
//   //   await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   // }
//
//   void getMapItems(BuildContext context1){
//     final eventTypeProvider = Provider.of<EventTypeProvider>(context1, listen: false);
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       useRootNavigator: true,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           height: MediaQuery.of(context).size.height* 0.5,
//           width: double.infinity,
//           decoration: BoxDecoration(
//               color: ThemeColors.black1.withOpacity(0.9),
//               borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               children: [
//                 const SizedBox(height: 20,),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InkWell(
//                       onTap: (){
//                         eventTypeProvider.updateEvent('Police');
//                         Navigator.pop(context);
//                       },
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Container(
//                             height: MySize.size100,
//                             width: MySize.size100,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: ThemeColors.fill2,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Image.asset(icPolice2,),
//                             ),
//                           ),
//                           const SizedBox(height: 10,),
//                           const Text('Police',style: TextStyle(color: ThemeColors.fillColor),)
//                         ],
//                       ),
//                     ),
//                     InkWell(
//                       onTap: (){
//                         eventTypeProvider.updateEvent('Car Crash');
//                         Navigator.pop(context);
//                       },
//                       child: Column(
//                         children: [
//                           Container(
//                             height: MySize.size100,
//                             width: MySize.size100,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: ThemeColors.fill2,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Image.asset(icCrash2),
//                             ),
//                           ),
//                           const SizedBox(height: 10,),
//                           const Text('Car Crash',style: TextStyle(color: ThemeColors.fillColor),)
//                         ],
//                       ),
//                     ),
//                     InkWell(
//                       onTap: (){
//                         eventTypeProvider.updateEvent('Hazard');
//                         Navigator.pop(context);
//                       },
//                       child: Column(
//                         children: [
//                           Container(
//                             height: MySize.size100,
//                             width: MySize.size100,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: ThemeColors.fill2,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(5.0),
//                               child: Image.asset(icWarning2),
//                             ),
//                           ),
//                           const SizedBox(height: 10,),
//                           const Text('Warning',style: TextStyle(color: ThemeColors.fillColor),)
//                         ],
//                       ),
//                     )
//
//                   ],
//                 ),
//                 const SizedBox(height: 30,),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       children: [
//                         InkWell(
//                           onTap: (){
//                             eventTypeProvider.updateEvent('Block');
//                             Navigator.pop(context);
//                           },
//                           child: Container(
//                             height: MySize.size100,
//                             width: MySize.size100,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: ThemeColors.fill2,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Image.asset(icRoadBlock2),
//                             ),
//                           ),
//                         ), const SizedBox(height: 10,),
//                         const Text('Road Block',style: TextStyle(color: ThemeColors.fillColor),)
//
//                       ],
//                     ),
//                     InkWell(
//                       onTap: (){
//                         eventTypeProvider.updateEvent('Warning');
//                         Navigator.pop(context);
//                       },
//                       child: Column(
//                         children: [
//                           Container(
//                             height: MySize.size100,
//                             width: MySize.size100,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: ThemeColors.fill2,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Image.asset(vlc2),
//                             ),
//                           ),
//                           const SizedBox(height: 10,),
//                           const Text('Hazard',style: TextStyle(color: ThemeColors.fillColor),)
//                         ],
//                       ),
//                     ),
//                     InkWell(
//                       onTap: (){
//                         eventTypeProvider.updateEvent('Traffic');
//                         Navigator.pop(context);
//                       },
//                       child: Column(
//                         children: [
//                           Container(
//                             height: MySize.size100,
//                             width: MySize.size100,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: ThemeColors.fill2,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(20.0),
//                               child: Image.asset(icTraffic2),
//                             ),
//                           ),
//                           const SizedBox(height: 10,),
//                           const Text('Traffic',style: TextStyle(color: ThemeColors.fillColor),)
//                         ],
//                       ),
//                     )
//
//                   ],
//                 ),
//
//               ],
//
//             ),
//           ), // Your content here,
//         );
//       },
//     );
//   }
//   void _onChanged() {
//     final currentSize = _controller.size;
//     if (currentSize <= 0.05) _collapse();
//   }
//
//   void _collapse() => _animateSheet(sheet.snapSizes!.first);
//
//   void _anchor() => _animateSheet(sheet.snapSizes!.last);
//
//   void _expand() => _animateSheet(sheet.maxChildSize);
//
//   void _hide() => _animateSheet(sheet.minChildSize);
//
//   void _animateSheet(double size) {
//     _controller.animateTo(
//       size,
//       duration: const Duration(milliseconds: 50),
//       curve: Curves.easeInOut,
//     );
//   }
//
// }