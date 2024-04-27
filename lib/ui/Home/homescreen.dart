import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:traffic_pro/providers/event_provider.dart';
import 'package:traffic_pro/ui/auth/auth_controller.dart';
import 'package:traffic_pro/ui/auth/login/login_view.dart';
import 'package:traffic_pro/ui/profile/profile_view.dart';
import 'dart:math' as math;

import '../../core/utils/functions.dart';
import '../../core/utils/image_paths.dart';
import '../../core/utils/mySize.dart';
import '../../core/utils/theme_helper.dart';
import '../qibla/qibla.dart';

import '../tests/test1.dart';


class HomeScreen extends StatefulWidget {
  final LatLng userLocation;
  const HomeScreen({super.key, required this.userLocation});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool _hasPermissions = false;
  AuthService authService = AuthService();
  final Completer<GoogleMapController> _mapController =
  Completer<GoogleMapController>();
  final List<Marker> _marker = <Marker>[];

  // final List<LatLng> _list = <LatLng>[
  //   const LatLng(33.977679, 71.446128),
  //   const LatLng(33.997276, 71.464931),
  // ];
  // final List<LatLng> _list2 = <LatLng>[
  //   const LatLng(  33.995970, 71.459224
  //   ),
  //   const LatLng(33.992329, 71.456626),
  // ];


  // loadData() async {
  //
  //   print(_list.length);
  //   for (int i = 0; i < _list.length; i++) {
  //     final Uint8List markerIcon = await getBytesfromassets(icpolice, 80);
  //
  //     _marker.add(
  //       Marker(
  //         markerId: MarkerId(i.toString()),
  //
  //         icon: BitmapDescriptor.fromBytes(markerIcon),
  //         // onTap: () {
  //         //   _customInfoWindowController.addInfoWindow!(
  //         //       Padding(
  //         //         padding:  EdgeInsets.symmetric(horizontal: MySize2.size40,vertical: MySize2.size20),
  //         //         child: Container(
  //         //
  //         //           decoration: BoxDecoration(
  //         //             borderRadius: BorderRadius.circular(15),
  //         //             color: primaryColor,
  //         //           ),
  //         //           child: StreamBuilder<QuerySnapshot>(
  //         //               stream: FirebaseFirestore.instance.collection('BoatData').snapshots(),
  //         //               builder: (context, snapshot) {
  //         //                 if(snapshot.hasError){
  //         //                   return Icon(Icons.error);
  //         //                 }
  //         //                 else if(snapshot.hasData){
  //         //                   var snap =snapshot.data!.docs[i];
  //         //                   String boatId = snap['boatId'];
  //         //                   return Stack(
  //         //                     clipBehavior: Clip.none,
  //         //                     children: [
  //         //                       Positioned(
  //         //                         top: -MySize2.size40,
  //         //                         left: MySize2.size15,
  //         //                         child: Container(
  //         //                             height: MySize2.size80,
  //         //                             width:MySize2.size140,
  //         //                             clipBehavior: Clip.hardEdge,
  //         //                             decoration: BoxDecoration(
  //         //                                 borderRadius: BorderRadius.circular(15)
  //         //                             ),
  //         //                             child: CachedNetworkImage(
  //         //                               imageUrl: snap['image1'],
  //         //                               fit: BoxFit.cover,
  //         //                               placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
  //         //                               errorWidget: (context, url, error) => const Icon(Icons.error),)
  //         //                         ),
  //         //                       ),
  //         //
  //         //                       Column(
  //         //                         crossAxisAlignment: CrossAxisAlignment.start,
  //         //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //                         children: [
  //         //                           Padding(
  //         //                             padding:  EdgeInsets.only(left: MySize2.size15, top: MySize2.size15),
  //         //                             child: Column(
  //         //                               crossAxisAlignment: CrossAxisAlignment.start,
  //         //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //
  //         //                               children: [
  //         //                                 // Row(
  //         //                                 //   children: [
  //         //                                 //     Container(
  //         //                                 //       height: 80,
  //         //                                 //       width: 120,
  //         //                                 //       child: CachedNetworkImage(
  //         //                                 //         imageUrl: snap['image1'],
  //         //                                 //         fit: BoxFit.cover,
  //         //                                 //         placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
  //         //                                 //         errorWidget: (context, url, error) => const Icon(Icons.error),)
  //         //                                 //     ),
  //         //                                 //     SizedBox(width: 10,),
  //         //                                 //
  //         //                                 //   ],
  //         //                                 // ),
  //         //                                 SizedBox(height: MySize2.size30,),
  //         //                                 Row(
  //         //                                   mainAxisAlignment: MainAxisAlignment.start,
  //         //
  //         //                                   children: [
  //         //                                     Text(snap['boatType'], style: TextStyle(
  //         //                                         color: Colors.white,
  //         //                                         fontSize: MySize2.size12, fontWeight: FontWeight.w500
  //         //                                     ),),
  //         //
  //         //                                   ],
  //         //                                 ),
  //         //                                 Row(
  //         //                                   mainAxisAlignment: MainAxisAlignment.start,
  //         //                                   children: [
  //         //                                     Icon(Icons.location_on, color: Colors.white.withOpacity(0.5),size: 8,),
  //         //
  //         //                                     Text(snap['area'], style: TextStyle(
  //         //                                         fontSize: MySize2.size6, fontWeight: FontWeight.w400,
  //         //                                         color: Colors.white
  //         //                                     ),overflow: TextOverflow.ellipsis,),
  //         //                                   ],
  //         //                                 ),
  //         //
  //         //                                 Row(
  //         //                                   mainAxisAlignment: MainAxisAlignment.start,
  //         //
  //         //                                   children: [
  //         //
  //         //                                     Container(
  //         //                                       width: width(context)*0.2,
  //         //                                       child: Text('\$ '+snap['boatPrice'], style: TextStyle(
  //         //                                           fontSize: MySize2.size10, fontWeight: FontWeight.w500,
  //         //                                           color: Colors.white
  //         //                                       ),overflow: TextOverflow.ellipsis,),
  //         //                                     ),
  //         //                                   ],
  //         //                                 ),
  //         //
  //         //
  //         //
  //         //
  //         //                               ],
  //         //                             ),
  //         //                           ),
  //         //
  //         //                           Container(
  //         //                             width: width(context),
  //         //                             height: MySize2.size40,
  //         //                             decoration: const BoxDecoration(
  //         //                                 color: Colors.white,
  //         //                                 borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
  //         //                             ),
  //         //                             child: Padding(
  //         //                               padding:  EdgeInsets.all(MySize2.size8),
  //         //                               child: Row(
  //         //                                 mainAxisAlignment: MainAxisAlignment.center,
  //         //                                 children: [
  //         //                                   InkWell(
  //         //                                       onTap: (){
  //         //                                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
  //         //                                             BoatDetails(boatId: snap['boatId'],
  //         //                                               // index: i
  //         //                                             )));
  //         //                                       },
  //         //                                       child: Text(AppLocale.viewDetails.getString(context),
  //         //                                         style: TextStyle(fontSize: MySize2.size10, fontWeight: FontWeight.w400, color: greyText),)),
  //         //                                 ],
  //         //                               ),
  //         //                             ),
  //         //                           )
  //         //                         ],
  //         //                       ),
  //         //                     ],
  //         //                   );
  //         //                 }else if(snapshot.connectionState == ConnectionState.waiting){
  //         //                   return CircularProgressIndicator();
  //         //                 }
  //         //                 return Container();
  //         //               }
  //         //           ),
  //         //         ),
  //         //       ),
  //         //       _list[i]);
  //         // },
  //         position: _list[i],
  //         // infoWindow: InfoWindow(title: 'My Home')
  //       ),
  //     );
  //     setState(() {});
  //   }
  // }
  // loadData2() async {
  //
  //   print(_list2.length);
  //   for (int i = 0; i < _list2.length; i++) {
  //     final Uint8List markerIcon = await getBytesfromassets(icCrash, 150);
  //
  //     _marker.add(
  //       Marker(
  //         markerId: MarkerId((i+2).toString()),
  //
  //         icon: BitmapDescriptor.fromBytes(markerIcon),
  //         // onTap: () {
  //         //   _customInfoWindowController.addInfoWindow!(
  //         //       Padding(
  //         //         padding:  EdgeInsets.symmetric(horizontal: MySize2.size40,vertical: MySize2.size20),
  //         //         child: Container(
  //         //
  //         //           decoration: BoxDecoration(
  //         //             borderRadius: BorderRadius.circular(15),
  //         //             color: primaryColor,
  //         //           ),
  //         //           child: StreamBuilder<QuerySnapshot>(
  //         //               stream: FirebaseFirestore.instance.collection('BoatData').snapshots(),
  //         //               builder: (context, snapshot) {
  //         //                 if(snapshot.hasError){
  //         //                   return Icon(Icons.error);
  //         //                 }
  //         //                 else if(snapshot.hasData){
  //         //                   var snap =snapshot.data!.docs[i];
  //         //                   String boatId = snap['boatId'];
  //         //                   return Stack(
  //         //                     clipBehavior: Clip.none,
  //         //                     children: [
  //         //                       Positioned(
  //         //                         top: -MySize2.size40,
  //         //                         left: MySize2.size15,
  //         //                         child: Container(
  //         //                             height: MySize2.size80,
  //         //                             width:MySize2.size140,
  //         //                             clipBehavior: Clip.hardEdge,
  //         //                             decoration: BoxDecoration(
  //         //                                 borderRadius: BorderRadius.circular(15)
  //         //                             ),
  //         //                             child: CachedNetworkImage(
  //         //                               imageUrl: snap['image1'],
  //         //                               fit: BoxFit.cover,
  //         //                               placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
  //         //                               errorWidget: (context, url, error) => const Icon(Icons.error),)
  //         //                         ),
  //         //                       ),
  //         //
  //         //                       Column(
  //         //                         crossAxisAlignment: CrossAxisAlignment.start,
  //         //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //                         children: [
  //         //                           Padding(
  //         //                             padding:  EdgeInsets.only(left: MySize2.size15, top: MySize2.size15),
  //         //                             child: Column(
  //         //                               crossAxisAlignment: CrossAxisAlignment.start,
  //         //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         //
  //         //                               children: [
  //         //                                 // Row(
  //         //                                 //   children: [
  //         //                                 //     Container(
  //         //                                 //       height: 80,
  //         //                                 //       width: 120,
  //         //                                 //       child: CachedNetworkImage(
  //         //                                 //         imageUrl: snap['image1'],
  //         //                                 //         fit: BoxFit.cover,
  //         //                                 //         placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
  //         //                                 //         errorWidget: (context, url, error) => const Icon(Icons.error),)
  //         //                                 //     ),
  //         //                                 //     SizedBox(width: 10,),
  //         //                                 //
  //         //                                 //   ],
  //         //                                 // ),
  //         //                                 SizedBox(height: MySize2.size30,),
  //         //                                 Row(
  //         //                                   mainAxisAlignment: MainAxisAlignment.start,
  //         //
  //         //                                   children: [
  //         //                                     Text(snap['boatType'], style: TextStyle(
  //         //                                         color: Colors.white,
  //         //                                         fontSize: MySize2.size12, fontWeight: FontWeight.w500
  //         //                                     ),),
  //         //
  //         //                                   ],
  //         //                                 ),
  //         //                                 Row(
  //         //                                   mainAxisAlignment: MainAxisAlignment.start,
  //         //                                   children: [
  //         //                                     Icon(Icons.location_on, color: Colors.white.withOpacity(0.5),size: 8,),
  //         //
  //         //                                     Text(snap['area'], style: TextStyle(
  //         //                                         fontSize: MySize2.size6, fontWeight: FontWeight.w400,
  //         //                                         color: Colors.white
  //         //                                     ),overflow: TextOverflow.ellipsis,),
  //         //                                   ],
  //         //                                 ),
  //         //
  //         //                                 Row(
  //         //                                   mainAxisAlignment: MainAxisAlignment.start,
  //         //
  //         //                                   children: [
  //         //
  //         //                                     Container(
  //         //                                       width: width(context)*0.2,
  //         //                                       child: Text('\$ '+snap['boatPrice'], style: TextStyle(
  //         //                                           fontSize: MySize2.size10, fontWeight: FontWeight.w500,
  //         //                                           color: Colors.white
  //         //                                       ),overflow: TextOverflow.ellipsis,),
  //         //                                     ),
  //         //                                   ],
  //         //                                 ),
  //         //
  //         //
  //         //
  //         //
  //         //                               ],
  //         //                             ),
  //         //                           ),
  //         //
  //         //                           Container(
  //         //                             width: width(context),
  //         //                             height: MySize2.size40,
  //         //                             decoration: const BoxDecoration(
  //         //                                 color: Colors.white,
  //         //                                 borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))
  //         //                             ),
  //         //                             child: Padding(
  //         //                               padding:  EdgeInsets.all(MySize2.size8),
  //         //                               child: Row(
  //         //                                 mainAxisAlignment: MainAxisAlignment.center,
  //         //                                 children: [
  //         //                                   InkWell(
  //         //                                       onTap: (){
  //         //                                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
  //         //                                             BoatDetails(boatId: snap['boatId'],
  //         //                                               // index: i
  //         //                                             )));
  //         //                                       },
  //         //                                       child: Text(AppLocale.viewDetails.getString(context),
  //         //                                         style: TextStyle(fontSize: MySize2.size10, fontWeight: FontWeight.w400, color: greyText),)),
  //         //                                 ],
  //         //                               ),
  //         //                             ),
  //         //                           )
  //         //                         ],
  //         //                       ),
  //         //                     ],
  //         //                   );
  //         //                 }else if(snapshot.connectionState == ConnectionState.waiting){
  //         //                   return CircularProgressIndicator();
  //         //                 }
  //         //                 return Container();
  //         //               }
  //         //           ),
  //         //         ),
  //         //       ),
  //         //       _list[i]);
  //         // },
  //         position: _list2[i],
  //         // infoWindow: InfoWindow(title: 'My Home')
  //       ),
  //     );
  //     setState(() {});
  //   }
  // }

  // final List<Marker> _marker = <Marker>[
  //   Marker(
  //     markerId: MarkerId('marker1'),
  //     position: LatLng(33.977679, 71.446128),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //   ),
  //   Marker(
  //     markerId: MarkerId('marker2'),
  //     position: LatLng(37.77483, -122.42942),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //   ),
  // ];


  var _policeIcon;
   var _roadBlockIcon;
   var _carCrashIcon;
  var _hazardIcon;
  var _warningIco;
  var _trafficIcon;

  Future<void> _loadCustomIcons() async {
    final List<String> iconPaths = [
      icTraffic2,
      icPolice2,
      icCrash2,
      icRoadBlock2,
      vlc2,
      icWarning2
    ];

    for (String path in iconPaths) {
      final ByteData bytes = await rootBundle.load(path);
      final Uint8List list = bytes.buffer.asUint8List();
      final BitmapDescriptor icon = BitmapDescriptor.fromBytes(list,size: const Size(1,1));

      if (path.contains('police')) {
         _policeIcon = icon;
      } else if (path.contains('road_block2')) {
        _roadBlockIcon = icon;
      } else if (path.contains('carCrash')) {
        _carCrashIcon = icon;
      }else if (path.contains('hazard')) {
        _hazardIcon = icon;
      }else if (path.contains('vlc')) {
        _warningIco = icon;
      }else if (path.contains('traffic')) {
        _trafficIcon = icon;
      }
    }
  }
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
    // loadData2();
    // loadData();

    // getUserCurrentLocation();
    _fetchPermissionStatus();

    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _anchor() => _animateSheet(sheet.snapSizes!.last);

  void _expand() => _animateSheet(sheet.maxChildSize);

  void _hide() => _animateSheet(sheet.minChildSize);

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  @override
  Widget build(BuildContext context) {

    // _marker.add(
    //     Marker(
    //   markerId: const MarkerId("user_location"),
    //   position: widget.userLocation,
    //   icon: BitmapDescriptor.defaultMarker,
    //   infoWindow: const InfoWindow(title: "Your Location"),)
    // );
    final eventprovider = Provider.of<EventTypeProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: ThemeColors.black1,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child:StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('markers').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            snapshot.data!.docs.forEach((doc) {
              BitmapDescriptor icon;

              switch (doc['eventType']) {
                case 'Police':
                  icon = _policeIcon;
                  break;
                case 'Traffic':
                  icon = _trafficIcon;
                  break;
                case 'Car Crash':
                  icon = _carCrashIcon;
                  break;
                case 'Hazard':
                  icon = _hazardIcon;
                  break;
                case 'Warning':
                  icon = _warningIco;
                  break;
                case 'Block':
                  icon = _roadBlockIcon;
                  break;
                default:
                  icon = BitmapDescriptor.defaultMarker;
              }

              // Add marker to the map
              Marker marker = Marker(

                markerId: MarkerId(doc.id),
                position: LatLng(doc['latitude'], doc['longitude']),
                icon: icon,
                infoWindow: InfoWindow(title: doc['eventType']),

              );
              _marker.add(marker);
            });
            return  Stack(
              children: [
                GoogleMap
                  (
                  onTap:(position)async{
                    if(eventprovider.event != ''){
                      var mar = await addMarker(position, eventprovider.event);
                      // _marker.add(mar);
                      eventprovider.updateEvent('');
                      setState(() {

                      });
                    }

                  } ,
                  trafficEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  // myLocationEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(target: widget.userLocation, zoom: 14),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  },
                  markers: Set<Marker>.of(_marker),

                ),
                Positioned(
                    top: 10,
                    left: 20,
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: ThemeColors.black1,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: IconButton(onPressed: (){
                          getDrawer();
                        }, icon: const Icon(Icons.menu, color: Colors.white,)))),
                Positioned(
                    top: 10,
                    right: 20,

                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: ThemeColors.black1,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: IconButton(icon: const Icon(Icons.compass_calibration_outlined, color: ThemeColors.fillColor,),
                        onPressed: (){
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=> MyApp()));
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                child: Container(
                                  height: MySize.size320,
                                  width: MySize.size350,
                                  decoration: BoxDecoration(
                                      color: ThemeColors.grey3,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Builder(builder: (context) {
                                      if (_hasPermissions) {
                                        return Column(
                                          children: <Widget>[
                                            Expanded(child: _buildCompass()),
                                          ],
                                        );
                                      } else {
                                        return _buildPermissionSheet();
                                      }
                                    }),
                                  ),
                                ),
                              );
                            },
                          );

                        },),
                    )),
                Positioned(
                    bottom: 120,
                    right: 20,

                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: ThemeColors.black1,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: IconButton(icon:  const Icon(Icons.search, color: ThemeColors.fillColor,),
                          onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> MapView(userLocation: widget.userLocation,)));
                          }),
                    )),
                Positioned(
                    bottom: 20,
                    right: 20,

                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: ThemeColors.black1,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: IconButton(icon:  const Icon(Icons.warning, color: ThemeColors.fillColor,),
                          onPressed: (){
                            getMapItems(context);
                          }),
                    )),
                Consumer<EventTypeProvider>(builder: (context, value,child){
                  return   eventprovider.event == '' ? SizedBox():
                  Positioned(
                      bottom: 20,
                      left: 20,

                      child: Container(
                          height: 50,
                          // width: 150,
                          decoration: BoxDecoration(
                              color: ThemeColors.black1,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text('Click on map to add ${eventprovider.event}',style: TextStyle(color: ThemeColors.fillColor),)),
                          )
                      ));
                })


              ],
            );
          },
        )
      ),
    );
  }
  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data!.heading;

        // if direction is null, then device does not support this sensor
        // show error message
        if (direction == null)
          return const Center(
            child: Text("Device does not have sensors !"),
          );

        return Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Transform.rotate(
              angle: (direction * (math.pi / 180) * -1),
              child: SvgPicture.asset('assets/svgs/compass.svg'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Location Permission Required'),
          ElevatedButton(
            child: const Text('Request Permissions'),
            onPressed: () {
              Permission.locationWhenInUse.request().then((ignored) {
                _fetchPermissionStatus();
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Open App Settings'),
            onPressed: () {
              openAppSettings().then((opened) {
                //
              });
            },
          )
        ],
      ),
    );
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() => _hasPermissions = status == PermissionStatus.granted);
      }
    });
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }

void getDrawer( ){
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        color: ThemeColors.black1.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: MySize.size30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: const Icon(Icons.close, color: ThemeColors.fillColor,))
                ],
              ),
              Row(
                children: [
                  Image(image: const AssetImage(iclogo),height: MySize.size40,width: MySize.size40,),
                  SizedBox(width: MySize.size15,),
                  const Text('Hello There!', style: TextStyle(fontSize: 20, color: ThemeColors.fillColor),),
                ],
              ),
              SizedBox(height: MySize.size15,),
              const Divider(
                thickness: 3,
                color: ThemeColors.grey1,
              ),
               ListTile(
                leading: const Icon(Icons.person, color: ThemeColors.fillColor,),
                title: const Text('Profile', style: TextStyle(fontSize: 14, color: ThemeColors.fillColor)),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProfileView()));
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Divider(
                  thickness: 0.5,
                  color: ThemeColors.grey1,
                ),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>QiblahCompass()));
                },
                leading: const Icon(Icons.compass_calibration_sharp, color: ThemeColors.fillColor,),
                title: const Text('Qibla', style: TextStyle(fontSize: 14, color: ThemeColors.fillColor)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Divider(
                  thickness: 0.5,
                  color: ThemeColors.grey1,
                ),
              ),

              const ListTile(
                leading: Icon(Icons.indeterminate_check_box_sharp, color: ThemeColors.fillColor,),
                title: Text('Terms and Conditions', style: TextStyle(fontSize: 14, color: ThemeColors.fillColor)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  thickness: 0.5,
                  color: ThemeColors.grey1,
                ),
              ),
              const ListTile(
                leading: Icon(Icons.privacy_tip, color: ThemeColors.fillColor,),
                title: Text('Privacy policy', style: TextStyle(fontSize: 14, color: ThemeColors.fillColor)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  thickness: 0.5,
                  color: ThemeColors.grey1,
                ),
              ),

               ListTile(
                leading: const Icon(Icons.logout, color: ThemeColors.fillColor,),
                title: const Text('Logout', style: TextStyle(fontSize: 14, color: ThemeColors.fillColor)),
                onTap: (){
                  authService.signOut().then((value){
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (context)=> const LoginView()), (route) => false);
                  });
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  thickness: 0.5,
                  color: ThemeColors.grey1,
                ),
              ),
            ],
          ),
        ), // Your content here,
      );
    },
  );
}
  void getMapItems(BuildContext context1){
    final eventTypeProvider = Provider.of<EventTypeProvider>(context1, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height* 0.5,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ThemeColors.black1.withOpacity(0.9),
borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        eventTypeProvider.updateEvent('Police');
                        Navigator.pop(context);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: MySize.size100,
                            width: MySize.size100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeColors.fill2,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(icPolice2,),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text('Police',style: TextStyle(color: ThemeColors.fillColor),)
                        ],
                      ),
                    ),
                    InkWell(
                        onTap: (){
                          eventTypeProvider.updateEvent('Car Crash');
                          Navigator.pop(context);
                        },
                      child: Column(
                        children: [
                          Container(
                            height: MySize.size100,
                            width: MySize.size100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeColors.fill2,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(icCrash2),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text('Car Crash',style: TextStyle(color: ThemeColors.fillColor),)
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        eventTypeProvider.updateEvent('Hazard');
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Container(
                            height: MySize.size100,
                            width: MySize.size100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeColors.fill2,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.asset(icWarning2),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text('Warning',style: TextStyle(color: ThemeColors.fillColor),)
                        ],
                      ),
                    )

                  ],
                ),
                const SizedBox(height: 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: (){
                            eventTypeProvider.updateEvent('Block');
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: MySize.size100,
                            width: MySize.size100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeColors.fill2,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(icRoadBlock2),
                            ),
                          ),
                        ), SizedBox(height: 10,),
                        Text('Road Block',style: TextStyle(color: ThemeColors.fillColor),)

                      ],
                    ),
                    InkWell(
                      onTap: (){
                        eventTypeProvider.updateEvent('Warning');
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Container(
                            height: MySize.size100,
                            width: MySize.size100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeColors.fill2,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(vlc2),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text('Hazard',style: TextStyle(color: ThemeColors.fillColor),)
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        eventTypeProvider.updateEvent('Traffic');
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Container(
                            height: MySize.size100,
                            width: MySize.size100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: ThemeColors.fill2,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(icTraffic2),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text('Traffic',style: TextStyle(color: ThemeColors.fillColor),)
                        ],
                      ),
                    )

                  ],
                ),

              ],

            ),
          ), // Your content here,
        );
      },
    );
  }

}