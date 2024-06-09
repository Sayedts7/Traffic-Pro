import 'package:flutter/material.dart';
import 'package:traffic_pro/core/utils/theme_helper.dart';
import 'package:traffic_pro/ui/Home/privacy_policy.dart';
import 'package:traffic_pro/ui/Home/terms_and_conditions.dart';
import 'package:traffic_pro/ui/auth/auth_controller.dart';

import '../../core/utils/image_paths.dart';
import '../../core/utils/mySize.dart';
import '../auth/login/login_view.dart';
import '../profile/profile_view.dart';
import '../qibla/qibla.dart';
import 'my_markers.dart';

AuthService authService = AuthService();
void  getDrawer( BuildContext context){
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyMarkers()));
                },
                leading: const Icon(Icons.compass_calibration_sharp, color: ThemeColors.fillColor,),
                title: const Text('My Markers', style: TextStyle(fontSize: 14, color: ThemeColors.fillColor)),
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

              ListTile(
                leading: Icon(Icons.indeterminate_check_box_sharp, color: ThemeColors.fillColor,),
                title: Text('Terms and Conditions', style: TextStyle(fontSize: 14, color: ThemeColors.fillColor)),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>  TermsAndConditionsScreen()));

                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  thickness: 0.5,
                  color: ThemeColors.grey1,
                ),
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip, color: ThemeColors.fillColor,),
                title: Text('Privacy policy', style: TextStyle(fontSize: 14, color: ThemeColors.fillColor)),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>  PrivacyPolicyScreen()));
                },
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
