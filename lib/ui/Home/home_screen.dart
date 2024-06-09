import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traffic_pro/ui/custom_widgets/custom_buttons.dart';

import '../../core/services/Maps functions.dart';
import '../../core/utils/functions.dart';
import '../../core/utils/image_paths.dart';
import '../../core/utils/mySize.dart';
import '../../core/utils/theme_helper.dart';
import '../../core/providers/event_provider.dart';
import '../custom_widgets/dialogs/custom_dialog.dart';
import '../custom_widgets/full_screen_image.dart';
import 'drawer.dart';
import 'dart:math' ;

import 'matrix/matrix_class.dart';
class HomeScreenView extends StatefulWidget {
  final LatLng userLocation;

  const HomeScreenView({super.key, required this.userLocation});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  @override
  void initState() {
    // TODO: implement initState
    _loadCustomIcons();
    _getCurrentLocation();
    _startMonitoringLocation();
    super.initState();
  }
  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _policeIcon;
  var _roadBlockIcon;
  var _carCrashIcon;
  var _hazardIcon;
  var _warningIco;
  var _trafficIcon;

  bool search = false;

  // from test class
   GoogleMapController? mapController;
  final CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();

  final List<Marker> _marker = <Marker>[];
  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  late Position _currentPosition;

  String _currentAddress = '';
  String _startAddress = '';
  String _destinationAddress = '';
  String? _placeDistance;

  late PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final eventprovider = Provider.of<EventTypeProvider>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeColors.black1,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                  onTap: () {
                    print(doc['imageUrl']);
                    print('0000000000000000000000000000000000000');
                    _customInfoWindowController.addInfoWindow!(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
                        child: Container(

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: ThemeColors.mainColor,
                            ),
                            child:                                   Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                          ImageFullscreen(imageUrl: doc['imageUrl'])));
                                      // ImageFullscreen(
                                      //   imageUrl: 'https://example.com/image.jpg', // Replace with your image URL
                                      // );
                                    },
                                    child: Container(
                                      height: MySize.size140,
                                      width:MySize.size140,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: Image.network(doc['imageUrl']),
                                      // child: CachedNetworkImage(
                                      //   imageUrl: doc['imageUrl'],
                                      //   fit: BoxFit.cover,
                                      //   placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                      //   errorWidget: (context, url, error) => const Icon(Icons.error),)
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      Text(doc['eventType'], style: TextStyle(
                                          color: Colors.white,
                                          fontSize: MySize.size12, fontWeight: FontWeight.w500
                                      ),),

                                      IconButton(onPressed: (){

                                        showDeleteDialog(context, 'Are you sure you want to delete this',
                                            doc.id, doc['userId'], doc['deleteCount'],
                                            widget.userLocation, false).then((value) {
                                          setState(() {

                                          });
                                        });

                                      }, icon: Icon(Icons.delete,size: 20,))

                                    ],
                                  ),





                                ],
                              ),
                            )

                        ),
                      ),
                      LatLng(doc['latitude'], doc['longitude']),
                    );
                  },
                  // infoWindow: InfoWindow(title: doc['eventType']),

                );
                _marker.add(marker);
              });
              return  Stack(
                children: [
                  GoogleMap
                    (
                    onTap:(position)async{
                      _customInfoWindowController.hideInfoWindow!();

                      if(eventprovider.event != ''){
                        await getImage(position, eventprovider.event).then((value) {
                          SnackBar(content: Text('added'));
                        });

                        // await addMarker(position, eventprovider.event);
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
                    polylines: Set<Polyline>.of(polylines.values),

                    onMapCreated: (GoogleMapController controller) {
                      print(snapshot.data!.docs.first['imageUrl']);
                      mapController = controller;
                      _customInfoWindowController.googleMapController = controller;

                      // _mapController.complete(controller);
                    },

                    onCameraMove: (position) {
                      _customInfoWindowController.onCameraMove!();
                    },
                    markers: Set<Marker>.of(_marker),


                  ),
                  CustomInfoWindow(
                    controller: _customInfoWindowController,
                    height: MySize.size250,
                    width: MySize.size220,
                    offset: 35,
                  ),
                  Visibility(
                    visible: search == true,
                    child: SafeArea(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                            width: width * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(width: 20,),
                                      const Text(
                                        'Search Route',
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      IconButton(onPressed: (){
                                        setState(() {
                                          search = false;
                                        });
                                        // Navigator.push(context, MaterialPageRoute(builder: (context)=> MapView(userLocation: widget.userLocation,)));
                                      }, icon: const Icon(Icons.close))
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  textField(
                                      label: 'Start',
                                      hint: 'Choose starting point',
                                      prefixIcon: const Icon(Icons.looks_one),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.my_location),
                                        onPressed: () {
                                          _getAddress();
                                          startAddressController.text = _currentAddress;
                                          _startAddress = _currentAddress;
                                        },
                                      ),
                                      controller: startAddressController,
                                      focusNode: startAddressFocusNode,
                                      width: width,
                                      locationCallback: (String value) {
                                        setState(() {
                                          _startAddress = value;
                                        });
                                      }),
                                  const SizedBox(height: 10),
                                  textField(
                                      label: 'Destination',
                                      hint: 'Choose destination',
                                      prefixIcon: const Icon(Icons.looks_two),
                                      controller: destinationAddressController,
                                      focusNode: desrinationAddressFocusNode,
                                      width: width,
                                      locationCallback: (String value) {
                                        setState(() {
                                          _destinationAddress = value;
                                        });
                                      }),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Visibility(
                                          visible: _placeDistance == null ? false : true,
                                          child: Text(
                                            'DISTANCE: $_placeDistance km',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: _placeDistance == null ? false : true,
                                          child: Text(
                                            //distanceText +' '+
                                            ' | Time: $duration',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomButton8(
                                        backgroundColor: Colors.grey,
                                        width:130,
                                        text: 'Clear', onPressed: (){
                                        startAddressFocusNode.unfocus();
                                        desrinationAddressFocusNode.unfocus();
                                        setState(() {
                                          if (_marker.isNotEmpty) _marker.clear();
                                          if (polylines.isNotEmpty)
                                            polylines.clear();
                                          if (polylineCoordinates.isNotEmpty)
                                            polylineCoordinates.clear();
                                          _placeDistance = null;
                                        });
                                      },),
                                      CustomButton8(
                                        backgroundColor: ThemeColors.mainColor,
                                        text: 'Show Route',
                                        width: 150,
                                        onPressed: (_startAddress != '' &&
                                            _destinationAddress != '')
                                            ? () async {
                                          fetchDistanceAndDuration(
                                            _startAddress,_destinationAddress
                                          );
                                          // calculateDistanceAndTime();
                                          startAddressFocusNode.unfocus();
                                          desrinationAddressFocusNode.unfocus();
                                          setState(() {
                                            if (_marker.isNotEmpty) _marker.clear();
                                            if (polylines.isNotEmpty)
                                              polylines.clear();
                                            if (polylineCoordinates.isNotEmpty)
                                              polylineCoordinates.clear();
                                            _placeDistance = null;
                                          });

                                          _calculateDistance().then((isCalculated) {
                                            if (isCalculated) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Distance Calculated Sucessfully'),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Error Calculating Distance'),
                                                ),
                                              );
                                            }
                                          });
                                        }
                                            : (){
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Enter location name in field'),
                                            ),
                                          );
                                        },
                                        // color: Colors.red,
                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius: BorderRadius.circular(20.0),
                                        // ),

                                      ),

                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Visibility(
                    visible: search == false,
                    child: Positioned(
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
                              getDrawer(context);
                            }, icon: const Icon(Icons.menu, color: Colors.white,)))),
                  ),
                  Visibility(
                    visible: search == false,
                    child: Positioned(
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
                                setState(() {
                                  search = true;
                                });
                              }),
                        )),
                  ),
                  Visibility(
                    visible: search == false,
                    child: Positioned(
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
                                getMapItems(context, context);
                              }),
                        )),
                  ),
                  Visibility(
                    visible: search == false,
                    child: Consumer<EventTypeProvider>(builder: (context, value,child){
                      return   eventprovider.event == '' ? const SizedBox():
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
                                child: Center(child: Text('Click on map to add ${eventprovider.event}',style: const TextStyle(color: ThemeColors.fillColor),)),
                              )
                          ));
                    }),
                  )


                ],
              );
            },
          )
      ),
    );
  }
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

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    try {
      // Retrieving placemarks from addresses
      List<Location>? startPlacemark = await locationFromAddress(_startAddress);
      List<Location>? destinationPlacemark =
      await locationFromAddress(_destinationAddress);

      // Use the retrieved coordinates of the current position,
      // instead of the address if the start position is user's
      // current position, as it results in better accuracy.
      double startLatitude = _startAddress == _currentAddress
          ? _currentPosition.latitude
          : startPlacemark[0].latitude;

      double startLongitude = _startAddress == _currentAddress
          ? _currentPosition.longitude
          : startPlacemark[0].longitude;

      double destinationLatitude = destinationPlacemark[0].latitude;
      double destinationLongitude = destinationPlacemark[0].longitude;

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString =
          '($destinationLatitude, $destinationLongitude)';

      // Start Location Marker
      Marker startMarker = Marker(
        markerId: MarkerId(startCoordinatesString),
        position: LatLng(startLatitude, startLongitude),
        infoWindow: InfoWindow(
          title: 'Start $startCoordinatesString',
          snippet: _startAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: MarkerId(destinationCoordinatesString),
        position: LatLng(destinationLatitude, destinationLongitude),
        infoWindow: InfoWindow(
          title: 'Destination $destinationCoordinatesString',
          snippet: _destinationAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Adding the markers to the list
      _marker.add(startMarker);
      _marker.add(destinationMarker);

      print(
        'START COORDINATES: ($startLatitude, $startLongitude)',
      );
      print(
        'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
      );

      // Calculating to check that the position relative
      // to the frame, and pan & zoom the camera accordingly.
      double miny = (startLatitude <= destinationLatitude)
          ? startLatitude
          : destinationLatitude;
      double minx = (startLongitude <= destinationLongitude)
          ? startLongitude
          : destinationLongitude;
      double maxy = (startLatitude <= destinationLatitude)
          ? destinationLatitude
          : startLatitude;
      double maxx = (startLongitude <= destinationLongitude)
          ? destinationLongitude
          : startLongitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      // Accommodate the two locations within the
      // camera view of the map
      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(northEastLatitude, northEastLongitude),
            southwest: LatLng(southWestLatitude, southWestLongitude),
          ),
          100.0,
        ),
      );

      // Calculating the distance between the start and the end positions
      // with a straight path, without considering any route
      // double distanceInMeters = await Geolocator().bearingBetween(
      //   startCoordinates.latitude,
      //   startCoordinates.longitude,
      //   destinationCoordinates.latitude,
      //   destinationCoordinates.longitude,
      // );

      await _createPolylines(startLatitude, startLongitude, destinationLatitude,
          destinationLongitude);

      double totalDistance = 0.0;

      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      setState(() {
        _placeDistance = totalDistance.toStringAsFixed(2);
        print('DISTANCE: $_placeDistance km');
      });

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Create the polylines for showing the route between two places
  _createPolylines(
      double startLatitude,
      double startLongitude,
      double destinationLatitude,
      double destinationLongitude,
      ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCUO40W_nDrilaL-2ny5RcWYpzHdlNil-M', // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.driving ,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = const PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }
  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }


  // this code is for telling user that there is traffic in the next signal
  LatLng targetPoint = LatLng(34.2397767, 71.95751); // Example target point
  double radius = 200; // 200 meters
  void _startMonitoringLocation() {
    print('====================================monitoring started');
    print('====================================}');

    Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high, // Set desired accuracy here
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        print(position.latitude);
        print(position.longitude);
        print(targetPoint.latitude);
        print(targetPoint.longitude);

      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        targetPoint.latitude,
        targetPoint.longitude,
      );

      if (distance <= radius) {
        _showReachedDialog();
      }
    });
  }

  void _showReachedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You have reached Jahaz chowk'),
          content: Text('You are informed that you might get stuck in traffic at Phase 3 chowk.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  final DistanceMatrixService distanceMatrixService =
  DistanceMatrixService('AIzaSyCUO40W_nDrilaL-2ny5RcWYpzHdlNil-M');
  String? distance;
  String? duration;
  String travelMode = 'driving';
  // Default travel mode

  void fetchDistanceAndDuration(String origin, String destination) async {
    print('here in fetchdistanceand duration');
    try {
      final result = await distanceMatrixService.getDistanceAndDuration(
        origin: origin,
        destination: destination,
        mode: travelMode,
      );
      setState(() {
        distance = result['distance'];
        duration = result['duration'];
        print('============================================');
        print(distance);
        print(duration);

        List<LatLng> polylinePoints = result['polylinePoints'];
        bool markerNearRoute = _checkMarkersNearRoute(polylinePoints);

        if (markerNearRoute) {
          // Add 10 minutes to duration
          duration = _addMinutesToDuration(duration!, 10);
        }

        print('Adjusted Duration: $duration');
      });
    } catch (e) {
      print(e);
    }
  }

  bool _checkMarkersNearRoute(List<LatLng> polylinePoints) {
    const double thresholdDistance = 0.5; // Define a threshold distance in km

    for (var marker in _marker) {
      for (var point in polylinePoints) {
        double distance = _calculateDistances(marker.position, point);
        if (distance <= thresholdDistance) {
          return true;
        }
      }
    }
    return false;
  }

  double _calculateDistances(LatLng start, LatLng end) {
    const double radiusOfEarthKm = 6371.0;

    double lat1 = start.latitude;
    double lon1 = start.longitude;
    double lat2 = end.latitude;
    double lon2 = end.longitude;

    double dLat = (lat2 - lat1) * (pi / 180.0);
    double dLon = (lon2 - lon1) * (pi / 180.0);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * (pi / 180.0)) * cos(lat2 * (pi / 180.0)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radiusOfEarthKm * c;
  }

  String _addMinutesToDuration(String duration, int minutesToAdd) {
    List<String> parts = duration.split(' ');
    int timeValue = int.parse(parts[0]);
    String unit = parts[1];

    if (unit.contains('hour')) {
      int totalMinutes = timeValue * 60 + minutesToAdd;
      return '${totalMinutes ~/ 60} hours ${totalMinutes % 60} mins';
    } else if (unit.contains('min')) {
      int totalMinutes = timeValue + minutesToAdd;
      return '$totalMinutes mins';
    } else {
      return duration; // Return original duration if format is not recognized
    }
  }// Method for retrieving the address
//
// Method for calculating the distance between two places
}
