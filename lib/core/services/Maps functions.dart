import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:geolocator/geolocator.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';
import '../utils/image_paths.dart';
import '../utils/mySize.dart';
import '../utils/theme_helper.dart';

Future<Uint8List> getBytesfromassets(String path, int width) async{
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
  ui.FrameInfo fi =await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))! .buffer.asUint8List();
}


Widget textField({
  required TextEditingController controller,
  required FocusNode focusNode,
  required String label,
  required String hint,
  required double width,
  required Icon prefixIcon,
  Widget? suffixIcon,
  required Function(String) locationCallback,
}) {
  return Container(
    width: width * 0.8,
    child: TextField(
      onChanged: (value) {
        locationCallback(value);
      },
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: Colors.blue.shade300,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.all(15),
        hintText: hint,
      ),
    ),
  );
}


Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

void getMapItems(BuildContext context1, BuildContext context){
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
                        const SizedBox(height: 10,),
                        const Text('Police',style: TextStyle(color: ThemeColors.fillColor),)
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
                        const SizedBox(height: 10,),
                        const Text('Car Crash',style: TextStyle(color: ThemeColors.fillColor),)
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
                        const SizedBox(height: 10,),
                        const Text('Warning',style: TextStyle(color: ThemeColors.fillColor),)
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
                      ), const SizedBox(height: 10,),
                      const Text('Road Block',style: TextStyle(color: ThemeColors.fillColor),)

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
                        const SizedBox(height: 10,),
                        const Text('Hazard',style: TextStyle(color: ThemeColors.fillColor),)
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
                        const SizedBox(height: 10,),
                        const Text('Traffic',style: TextStyle(color: ThemeColors.fillColor),)
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

