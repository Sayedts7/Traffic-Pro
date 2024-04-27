import 'package:flutter/material.dart';
import 'package:traffic_pro/ui/splash_services.dart';
import '../core/utils/image_paths.dart';
import '../core/utils/mySize.dart';
import '../core/utils/theme_helper.dart';


// splash screen is the 1st screen a user see. Normally we have a logo on this screen.
// we run some important function in background as the app starts
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices services = SplashServices();
  @override
  void initState() {

    super.initState();

    // this code calls the function to check if user is already logged in or not
    services.isLogin(context);

  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return  Scaffold(
        body: Container(
          decoration: const BoxDecoration(
           color: ThemeColors.backgroundColor
          ),

          child:  Center(
              child: Padding(
                padding: EdgeInsets.all(MySize.size80),
                //iclogo is path of image from our assets folder, clicking on it with ctrl press takes you to that screen
                child: const Image(image: AssetImage(iclogo)),
              )),
        ));
  }

}
