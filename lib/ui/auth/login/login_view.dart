// ignore_for_file: must_be_immutable, use_build_context_synchronously



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/common_functions.dart';
import '../../../core/utils/image_paths.dart';
import '../../../core/utils/mySize.dart';
import '../../../core/utils/theme_helper.dart';
import '../../Home/home_2_test.dart';
import '../../Home/homescreen.dart';
import '../../custom_widgets/custom_buttons.dart';
import '../../custom_widgets/custom_textfields.dart';
import '../../custom_widgets/loader_view.dart';
import '../../custom_widgets/scrollable_column.dart';
import '../auth_controller.dart';
import '../signup/sign_up_screen.dart';
import 'login_provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  AuthService authService = AuthService();
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  // TextEditingController forgetPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // @override
  // void dispose() {
  //   emailController.dispose();
  //   passwordController.dispose();
  //   forgetPasswordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: ThemeColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: ThemeColors.backgroundColor,
            elevation: 0.0,
            title: const Text('Login', style: TextStyle(color: Colors.white),),
            centerTitle: true,
            automaticallyImplyLeading: false,
            // leading: IconButton(onPressed: (){
            //   Navigator.pop(context);
            // },
            //     icon: Icon(Icons.arrow_back_ios, color: Colors.white,)),
            //
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
                style: const ButtonStyle(


                  overlayColor: MaterialStatePropertyAll(Colors.transparent),
                ),
                child: Text(
                  'Sign Up',//AppLocalizations.of(context)!.join.toString(),
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MySize.size14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: ScrollableColumn(
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: MySize.size20),
                  child: Image.asset(iclogo, height: MySize.size150,),
                ),
                Text(
                  'Welcome Back',//AppLocalizations.of(context)!.welcomeToBack.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ThemeColors.fillColor,
                    fontSize: MySize.size28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: MySize.size2),
                Text(
                  'Welcome to Traffic Pro',
                  // AppLocalizations.of(context)!
                  //     .welcomeBackDescription
                  //     .toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ThemeColors.grey1,
                    fontSize: MySize.size12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: MySize.size25),
                Form(
                  key: _loginKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: Spacing.horizontal(MySize.size32),
                        child: CustomTextField13(
                          controller: emailController,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.emailAddress,
                          hintText:'Enter email',
                              // AppLocalizations.of(context)!.email.toString(),
                          fillColor: ThemeColors.fillColor,
                          validator: (value) {
                            return CommonFunctions.validateTextField(value);
                          },
                        ),
                      ),
                      SizedBox(height: MySize.size15),
                      Padding(
                        padding: Spacing.horizontal(MySize.size32),
                        child: Consumer<LoginProvider>(
                          builder: (context, p, child) =>
                              CustomTextField13(
                            controller: passwordController,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.text,
                            hintText: 'Password',
                            // AppLocalizations.of(context)!
                            //     .password
                            //     .toString(),
                            fillColor: ThemeColors.fillColor,
                            sufixIcon: p.obsecureText
                                ? GestureDetector(
                                    onTap: () {
                                      p.setObsecureText(!p.obsecureText);
                                    },
                                    child: const Icon(
                                      Icons.visibility_off_outlined,
                                      color: ThemeColors.mainColor,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      p.setObsecureText(!p.obsecureText);
                                    },
                                    child: const Icon(
                                      Icons.visibility_outlined,
                                      color: ThemeColors.mainColor,
                                    ),
                                  ),
                            obscureText: p.obsecureText,
                            validator: (value) {
                              return CommonFunctions.validateTextField(value);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MySize.size10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Padding(
                //       padding: Spacing.horizontal(MySize.size32),
                //       child: TextButton(
                //         onPressed: () {
                //           showCustomBottomSheet(context);
                //         },
                //         style: const ButtonStyle(
                //           overlayColor:
                //               MaterialStatePropertyAll(Colors.transparent),
                //         ),
                //         child: Text(
                //           'Forget Password?',
                //           // AppLocalizations.of(context)!
                //           //     .forgetpassword
                //           //     .toString(),
                //           textAlign: TextAlign.right,
                //           style: TextStyle(
                //             color: ThemeColors.fillColor,
                //             fontSize: MySize.size12,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: MySize.size20),
                Consumer<LoginProvider>(
                  builder: (context, p, child) => Padding(
                    padding: Spacing.horizontal(MySize.size32),
                    child: CustomButton8(

                      text: 'Login',//AppLocalizations.of(context)!.signin.toString(),
                       backgroundColor: ThemeColors.mainColor,
                      // gradient: ThemeColors.myGradient,
                      textColor: ThemeColors.fillColor,
                      radius: 10,
                      onPressed: () async {
                        CommonFunctions.closeKeyboard(context);
                        if (_loginKey.currentState!.validate()) {


                          String email = emailController.text;
                          String password = passwordController.text;

                          bool isConnected = await CommonFunctions.checkInternetConnection();
                          //internet check here
                          if(isConnected){
                            p.changeShowLoaderValue(true);

                            final UserCredential? userCredential = await authService
                              .signInWithEmail(context, email, password);
                          if (userCredential != null) {
                            //this line of code stops the loading
                            var location = await CommonFunctions.getUserCurrentLocation();
                            LatLng userLocation = LatLng(location.latitude, location.longitude);
                            p.changeShowLoaderValue(false);


                          }
                          else{
                            p.changeShowLoaderValue(false);

                          }
                          }else {
                            p.changeShowLoaderValue(false);
                            //show the dialog if internet is not available
                            CommonFunctions.showNoInternetDialog(context);
                          }



                          clearTextFormFields();
                        } else {
                          CommonFunctions.flushBarErrorMessage(
                              // AppLocalizations.of(context)!
                              //     .fieldRequired
                              //     .toString(),
                            'required',
                              context);
                        }
                        // await loginBtn();
                      },
                    ),
                  ),
                ),
                SizedBox(height: MySize.size20),
                SizedBox(height: MySize.size30),
              ],
            ),
          ),
        ),
        Consumer<LoginProvider>(
          builder: (context, p, child) =>
              p.showLoader ? const LoaderView() : Container(),
        ),
      ],
    );
  }


  clearTextFormFields() {
    // forgetPasswordController.clear();
    passwordController.clear();
    emailController.clear();
  }
}
