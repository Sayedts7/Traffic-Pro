// import 'dart:async';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_compass/flutter_compass.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:custom_info_window/custom_info_window.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:traffic_pro/providers/event_provider.dart';
// import 'package:traffic_pro/ui/Home/privacy_policy.dart';
// import 'package:traffic_pro/ui/Home/terms_and_conditions.dart';
// import 'package:traffic_pro/ui/auth/auth_controller.dart';
// import 'package:traffic_pro/ui/auth/login/login_view.dart';
// import 'package:traffic_pro/ui/custom_widgets/dialogs/custom_dialog.dart';
// import 'package:traffic_pro/ui/profile/profile_view.dart';
// import 'dart:math' as math;
//
// import '../../core/providers/loading_provider.dart';
// import '../../core/services/Maps functions.dart';
// import '../../core/utils/functions.dart';
// import '../../core/utils/image_paths.dart';
// import '../../core/utils/mySize.dart';
// import '../../core/utils/theme_helper.dart';
// import '../custom_widgets/full_screen_image.dart';
// import '../qibla/qibla.dart';
//
// import '../tests/test1.dart';
// import 'dart:convert';
//
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
//
// import 'dart:math' show cos, sqrt, asin;
//
// import 'drawer.dart';
// import 'matrix/matrix_class.dart';
// import 'my_markers.dart';
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
//
//
//
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
//   // Method for retrieving the current location
//   String distanceText = '';
//   String travelTimeText = '';
//
// // this function needs to be commented.
// //   Future<void> calculateDistanceAndTime() async {
// //
// //     final url =
// //         'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$_startAddress&destinations=$_destinationAddress&mode=walking&key=AIzaSyCUO40W_nDrilaL-2ny5RcWYpzHdlNil-M';
// //     final response = await http.get(Uri.parse(url));
// //
// //     if (response.statusCode == 200) {
// //       final data = jsonDecode(response.body);
// //       final elements = data['rows'][0]['elements'];
// //       final distance = elements[0]['distance']['value'];
// //       final duration = elements[0]['duration']['value'];
// //
// //       setState(() {
// //         distanceText = '${distance / 1000} km';
// //         travelTimeText = '${Duration(seconds: duration).inMinutes} mins';
// //         print(data);
// //         print('-------------------------------');
// //         print(distanceText);
// //       });
// //
// //       // Check for markers along the route (implementation details omitted for brevity)
// //     } else {
// //       // Handle API errors
// //     }
// //   }
//
//   final DistanceMatrixService distanceMatrixService =
//   DistanceMatrixService('AIzaSyCUO40W_nDrilaL-2ny5RcWYpzHdlNil-M');
//   String? distance;
//   String? duration;
//   String travelMode = 'driving';
//   // Default travel mode
//
//   void fetchDistanceAndDuration() async {
//     print('here in fetchdistanceand duration');
//     try {
//       final result = await distanceMatrixService.getDistanceAndDuration(
//         origin: 'New+York,NY',
//         destination: 'Los+Angeles,CA',
//         mode: travelMode,
//       );
//       setState(() {
//         distance = result['distance'];
//         duration = result['duration'];
//         print('============================================');
//         print(distance);
//         print(duration);
//
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//   // Method for retrieving the address
//   //
//   // Method for calculating the distance between two places
//
//   //////////////////////////////////////////////////
//   final Completer<GoogleMapController> _mapController =
//   Completer<GoogleMapController>();
//
//
//   final _controller = DraggableScrollableController();
//
//   @override
//   void initState() {
//     super.initState();
//
//      _getCurrentLocation();
//       _startMonitoringLocation();
//
//
//     // fetchDistanceAndDuration();
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
//         child:StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('markers').snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const CircularProgressIndicator();
//             }
//             snapshot.data!.docs.forEach((doc) {
//               BitmapDescriptor icon;
//
//               switch (doc['eventType']) {
//                 case 'Police':
//                   icon = _policeIcon;
//                   break;
//                 case 'Traffic':
//                   icon = _trafficIcon;
//                   break;
//                 case 'Car Crash':
//                   icon = _carCrashIcon;
//                   break;
//                 case 'Hazard':
//                   icon = _hazardIcon;
//                   break;
//                 case 'Warning':
//                   icon = _warningIco;
//                   break;
//                 case 'Block':
//                   icon = _roadBlockIcon;
//                   break;
//                 default:
//                   icon = BitmapDescriptor.defaultMarker;
//               }
//
//               // Add marker to the map
//               Marker marker = Marker(
//
//                 markerId: MarkerId(doc.id),
//                 position: LatLng(doc['latitude'], doc['longitude']),
//                 icon: icon,
//                 onTap: () {
//                   print(doc['imageUrl']);
//                   print('0000000000000000000000000000000000000');
//                   _customInfoWindowController.addInfoWindow!(
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
//                         child: Container(
//
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             color: ThemeColors.mainColor,
//                           ),
//                           child:                                   Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                               children: [
//                                 InkWell(
//                                   onTap: (){
//                                     Navigator.push(context, MaterialPageRoute(builder: (context) =>
//                                         ImageFullscreen(imageUrl: doc['imageUrl'])));
//                                     // ImageFullscreen(
//                                     //   imageUrl: 'https://example.com/image.jpg', // Replace with your image URL
//                                     // );
//                                   },
//                                   child: Container(
//                                     height: MySize.size140,
//                                     width:MySize.size140,
//                                     clipBehavior: Clip.hardEdge,
//                                     decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(15)
//                                     ),
//                                     child: Image.network(doc['imageUrl']),
//                                     // child: CachedNetworkImage(
//                                     //   imageUrl: doc['imageUrl'],
//                                     //   fit: BoxFit.cover,
//                                     //   placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
//                                     //   errorWidget: (context, url, error) => const Icon(Icons.error),)
//                                   ),
//                                 ),
//
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                                   children: [
//                                     Text(doc['eventType'], style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: MySize.size12, fontWeight: FontWeight.w500
//                                     ),),
//
//                                     IconButton(onPressed: (){
//
//                                       showDeleteDialog(context, 'Are you sure you want to delete this',
//                                           doc.id, doc['userId'], doc['deleteCount'],
//                                           widget.userLocation, false).then((value) {
//                                             setState(() {
//
//                                             });
//                                       });
//
//                                     }, icon: Icon(Icons.delete,size: 20,))
//
//                                   ],
//                                 ),
//
//
//
//
//
//                               ],
//                             ),
//                           )
//
//                                               ),
//                       ),
//                     LatLng(doc['latitude'], doc['longitude']),
//                      );
//                 },
//                 // infoWindow: InfoWindow(title: doc['eventType']),
//
//               );
//               _marker.add(marker);
//             });
//             return  Stack(
//               children: [
//                 GoogleMap
//                   (
//                   onTap:(position)async{
//                     _customInfoWindowController.hideInfoWindow!();
//
//                     if(eventprovider.event != ''){
//                       await getImage(position, eventprovider.event).then((value) {
//                         SnackBar(content: Text('added'));
//                       });
//
//                       // await addMarker(position, eventprovider.event);
//                       // _marker.add(mar);
//                       eventprovider.updateEvent('');
//                       setState(() {
//
//                       });
//                     }
//
//                   } ,
//                   trafficEnabled: true,
//                   zoomControlsEnabled: false,
//                   myLocationButtonEnabled: true,
//                   myLocationEnabled: true,
//                   // myLocationEnabled: true,
//                   mapType: MapType.normal,
//                   initialCameraPosition: CameraPosition(target: widget.userLocation, zoom: 14),
//                   polylines: Set<Polyline>.of(polylines.values),
//
//                   onMapCreated: (GoogleMapController controller) {
//                     print(snapshot.data!.docs.first['imageUrl']);
//                     mapController = controller;
//                     _customInfoWindowController.googleMapController = controller;
//
//                     // _mapController.complete(controller);
//                   },
//
//                   onCameraMove: (position) {
//                     _customInfoWindowController.onCameraMove!();
//                   },
//                   markers: Set<Marker>.of(_marker),
//
//
//                 ),
//                 CustomInfoWindow(
//                   controller: _customInfoWindowController,
//                   height: MySize.size250,
//                   width: MySize.size220,
//                   offset: 35,
//                 ),
//                 Visibility(
//                   visible: search == true,
//                   child: SafeArea(
//                     child: Align(
//                       alignment: Alignment.topCenter,
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 10.0),
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             color: Colors.white70,
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(20.0),
//                             ),
//                           ),
//                           width: width * 0.9,
//                           child: Padding(
//                             padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: <Widget>[
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     const SizedBox(width: 20,),
//                                     const Text(
//                                       'Search Route',
//                                       style: TextStyle(fontSize: 20.0),
//                                     ),
//                                     IconButton(onPressed: (){
//                                       setState(() {
//                                         search = false;
//                                       });
//                                       // Navigator.push(context, MaterialPageRoute(builder: (context)=> MapView(userLocation: widget.userLocation,)));
//                                     }, icon: const Icon(Icons.close))
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 textField(
//                                     label: 'Start',
//                                     hint: 'Choose starting point',
//                                     prefixIcon: const Icon(Icons.looks_one),
//                                     suffixIcon: IconButton(
//                                       icon: const Icon(Icons.my_location),
//                                       onPressed: () {
//                                         _getAddress();
//                                         startAddressController.text = _currentAddress;
//                                         _startAddress = _currentAddress;
//                                       },
//                                     ),
//                                     controller: startAddressController,
//                                     focusNode: startAddressFocusNode,
//                                     width: width,
//                                     locationCallback: (String value) {
//                                       setState(() {
//                                         _startAddress = value;
//                                       });
//                                     }),
//                                 const SizedBox(height: 10),
//                                 textField(
//                                     label: 'Destination',
//                                     hint: 'Choose destination',
//                                     prefixIcon: const Icon(Icons.looks_two),
//                                     controller: destinationAddressController,
//                                     focusNode: desrinationAddressFocusNode,
//                                     width: width,
//                                     locationCallback: (String value) {
//                                       setState(() {
//                                         _destinationAddress = value;
//                                       });
//                                     }),
//                                 const SizedBox(height: 10),
//                                 Padding(
//                                   padding: const EdgeInsets.all(15.0),
//                                   child: Row(
//                                     children: [
//                                       Visibility(
//                                         visible: _placeDistance == null ? false : true,
//                                         child: Text(
//                                           'DISTANCE: $_placeDistance km',
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                       Visibility(
//                                         visible: _placeDistance == null ? false : true,
//                                         child: Text(
//                                           //distanceText +' '+
//                                           ' | Time: $travelTimeText',
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 5),
//                                 ElevatedButton(
//
//                                   onPressed: (_startAddress != '' &&
//                                       _destinationAddress != '')
//                                       ? () async {
//                                     calculateDistanceAndTime();
//                                     startAddressFocusNode.unfocus();
//                                     desrinationAddressFocusNode.unfocus();
//                                     setState(() {
//                                       if (_marker.isNotEmpty) _marker.clear();
//                                       if (polylines.isNotEmpty)
//                                         polylines.clear();
//                                       if (polylineCoordinates.isNotEmpty)
//                                         polylineCoordinates.clear();
//                                       _placeDistance = null;
//                                     });
//
//                                     _calculateDistance().then((isCalculated) {
//                                       if (isCalculated) {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           const SnackBar(
//                                             content: Text(
//                                                 'Distance Calculated Sucessfully'),
//                                           ),
//                                         );
//                                       } else {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           const SnackBar(
//                                             content: Text(
//                                                 'Error Calculating Distance'),
//                                           ),
//                                         );
//                                       }
//                                     });
//                                   }
//                                       : (){
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(
//             const SnackBar(
//             content: Text(
//             'Enter location name in field'),
//             ),
//             );
//                                   },
//                                   // color: Colors.red,
//                                   // shape: RoundedRectangleBorder(
//                                   //   borderRadius: BorderRadius.circular(20.0),
//                                   // ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                       'Show Route'.toUpperCase(),
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 20.0,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 Visibility(
//                   visible: search == false,
//                   child: Positioned(
//                       top: 10,
//                       left: 20,
//                       child: Container(
//                           height: 50,
//                           width: 50,
//                           decoration: BoxDecoration(
//                               color: ThemeColors.black1,
//                               borderRadius: BorderRadius.circular(10)
//                           ),
//                           child: IconButton(onPressed: (){
//                             getDrawer(context);
//                           }, icon: const Icon(Icons.menu, color: Colors.white,)))),
//                 ),
//                 Visibility(
//                   visible: search == false,
//                   child: Positioned(
//                       top: 10,
//                       right: 20,
//
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         decoration: BoxDecoration(
//                             color: ThemeColors.black1,
//                             borderRadius: BorderRadius.circular(10)
//                         ),
//                         child: IconButton(icon: const Icon(Icons.compass_calibration_outlined, color: ThemeColors.fillColor,),
//                           onPressed: (){
//                             // Navigator.push(context, MaterialPageRoute(builder: (context)=> MyApp()));
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return Dialog(
//                                   child: Container(
//                                     height: MySize.size320,
//                                     width: MySize.size350,
//                                     decoration: BoxDecoration(
//                                         color: ThemeColors.grey3,
//                                         borderRadius: BorderRadius.circular(20)
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Builder(builder: (context) {
//                                         if (_hasPermissions) {
//                                           return Column(
//                                             children: <Widget>[
//                                               Expanded(child: _buildCompass()),
//                                             ],
//                                           );
//                                         } else {
//                                           return _buildPermissionSheet();
//                                         }
//                                       }),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             );
//
//                           },),
//                       )),
//                 ),
//                 Visibility(
//                   visible: search == false,
//                   child: Positioned(
//                       bottom: 120,
//                       right: 20,
//
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         decoration: BoxDecoration(
//                             color: ThemeColors.black1,
//                             borderRadius: BorderRadius.circular(10)
//                         ),
//                         child: IconButton(icon:  const Icon(Icons.search, color: ThemeColors.fillColor,),
//                             onPressed: (){
//                           setState(() {
//                             search = true;
//                           });
//                             }),
//                       )),
//                 ),
//                 Visibility(
//                   visible: search == false,
//                   child: Positioned(
//                       bottom: 20,
//                       right: 20,
//
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         decoration: BoxDecoration(
//                             color: ThemeColors.black1,
//                             borderRadius: BorderRadius.circular(10)
//                         ),
//                         child: IconButton(icon:  const Icon(Icons.warning, color: ThemeColors.fillColor,),
//                             onPressed: (){
//                               getMapItems(context);
//                             }),
//                       )),
//                 ),
//                 Visibility(
//                   visible: search == false,
//                   child: Consumer<EventTypeProvider>(builder: (context, value,child){
//                     return   eventprovider.event == '' ? const SizedBox():
//                     Positioned(
//                         bottom: 20,
//                         left: 20,
//
//                         child: Container(
//                             height: 50,
//                             // width: 150,
//                             decoration: BoxDecoration(
//                                 color: ThemeColors.black1,
//                                 borderRadius: BorderRadius.circular(10)
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Center(child: Text('Click on map to add ${eventprovider.event}',style: const TextStyle(color: ThemeColors.fillColor),)),
//                             )
//                         ));
//                   }),
//                 )
//
//
//               ],
//             );
//           },
//         )
//       ),
//     );
//   }
//
//
//
// }