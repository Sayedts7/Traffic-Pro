

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traffic_pro/core/utils/common_functions.dart';
import 'package:traffic_pro/ui/Home/homescreen.dart';
import 'package:traffic_pro/ui/auth/auth_controller.dart';
import '../../../core/utils/image_paths.dart';
import '../../../core/utils/mySize.dart';
import '../../../core/utils/theme_helper.dart';
import '../../custom_widgets/custom_buttons.dart';
import '../../custom_widgets/custom_textfields.dart';
import '../login/login_provider.dart';



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameCon = TextEditingController();
  final TextEditingController contactCon = TextEditingController();
  final TextEditingController createPasswordCon = TextEditingController();
  final TextEditingController confirmPasswordCon = TextEditingController();
  // AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ThemeColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeColors.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,


        title:  Text(
          'Register',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ThemeColors.fillColor,
            fontSize: MySize.size16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),

        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child:  Padding(
              padding: EdgeInsets.all(MySize.size20),
              child: const Center(
                child: Text(
                  'Sign In',
                  //textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ThemeColors.grey2,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(MySize.size20),
            child: Column(
              children: [
                Padding(
                  padding:  EdgeInsets.only(bottom: MySize.size20),
                  child: Image.asset(iclogo, height: MySize.size150,),
                ),
                Text(
                  'Join us!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ThemeColors.fillColor,
                    fontSize: MySize.size28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: MySize.size10,),
                Form(
                  key: _formKey,
                  child: Consumer<LoginProvider>(builder: (context, p, child) {
                    return Column(
                      children: [
                        CustomTextField13(
                          controller: fullNameCon,
                          hintText: 'Full Name',
                          keyboardType: TextInputType.name,

                        ),
                        SizedBox(height: MySize.size20),
                        CustomTextField13(
                          controller: emailController,
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,

                        ),
                        SizedBox(height: MySize.size20),
                        CustomTextField13(
                          controller: createPasswordCon,
                          hintText: 'Create Password',
                          keyboardType: TextInputType.visiblePassword,

                          sufixIcon: p.obsecureText
                              ? GestureDetector(
                                  onTap: () {
                                    p.setObsecureText(!p.obsecureText);
                                  },
                                  child: const Icon(
                                    Icons.visibility_off_outlined,
                                    color: ThemeColors.grey1,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    p.setObsecureText(!p.obsecureText);
                                  },
                                  child: const Icon(
                                    Icons.visibility_outlined,
                                    color: ThemeColors.grey3,
                                  ),
                                ),
                          obscureText: p.obsecureText,
                        ),
                          SizedBox(height: MySize.size20),


                        CustomTextField13(
                          controller: confirmPasswordCon,
                          hintText: 'Confirm Password',
                          keyboardType: TextInputType.visiblePassword,

                          sufixIcon: p.obsecureText
                              ? GestureDetector(
                                  onTap: () {
                                    p.setObsecureText(!p.obsecureText);
                                  },
                                  child: const Icon(
                                    Icons.visibility_off_outlined,
                                    color: ThemeColors.grey3,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    p.setObsecureText(!p.obsecureText);
                                  },
                                  child: const Icon(
                                    Icons.visibility_outlined,
                                    color: ThemeColors.grey3,
                                  ),
                                ),
                          obscureText: p.obsecureText
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(height: MySize.size20),
                // ),
                Column(
                  children: [
                    Consumer<LoginProvider>(
                      builder: (context, p, child) => Padding(
                        padding: EdgeInsets.only(
                          top:
                             MySize.size20),
                        child: p.showLoader
                            ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                            : CustomButton8(

                          text: 'Sign Up',

                          onPressed: () async {
                            _submitForm();

                          },
                          // gradient: ThemeColors.myGradient,
                          backgroundColor: ThemeColors.mainColor,
                          textColor: ThemeColors.fillColor,
                        ),
                      ),
                    )

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // this function is called when you click the sign up button
  void _submitForm() async{

    //initializing provider for showing loading when needed
    final obj = Provider.of<LoginProvider>(context,
        listen: false);

    //if condition for checking if validators checking
    if (_formKey.currentState!.validate()) {
      // Form is valid, perform login or other actions
      String email = emailController.text;
      String password = createPasswordCon.text;
      String confirmPassword = confirmPasswordCon.text;
      String name = fullNameCon.text;


      if(password == confirmPassword){
        //internet check here
        bool isConnected = await CommonFunctions.checkInternetConnection();
        if(isConnected == true){

          //this line of code starts the loading
          obj.changeShowLoaderValue(true);


            final UserCredential? userCredential = await authService.signUpWithEmail(context,email, password);
            if (userCredential != null) {
              // Authentication successful, navigate to the next screen
              authService.setData(email,name ).then((value) async {

                //this line of code stops the loading
                obj.changeShowLoaderValue(false);
                var location = await CommonFunctions.getUserCurrentLocation();
                LatLng userLocation = LatLng(location.latitude, location.longitude);

                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen(userLocation: userLocation)));
              }).onError((error, stackTrace) {
                print(error.toString());
                obj.changeShowLoaderValue(false);

              });      } else {
              //this line of code stops the loading
              obj.changeShowLoaderValue(false);
}
        }
        else{

          CommonFunctions.showNoInternetDialog(context);
        }
      }else{
        CommonFunctions.authErrorSnackbar(context, 'Password mismatch', 'Your password does not match');

      }

      // Perform login logic here
      if (kDebugMode) {
        print('Login with Email: $email, Password: $password');
      }
    }
  }

}
