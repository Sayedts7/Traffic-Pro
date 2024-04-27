// ignore_for_file: must_be_immutable, use_build_context_synchronously



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/common_functions.dart';
import '../../../core/utils/image_paths.dart';
import '../../../core/utils/mySize.dart';
import '../../../core/utils/theme_helper.dart';
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
  TextEditingController forgetPasswordController = TextEditingController();
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
                          builder: (context, p, child) => CustomTextField13(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: Spacing.horizontal(MySize.size32),
                      child: TextButton(
                        onPressed: () {
                          showCustomBottomSheet(context);
                        },
                        style: const ButtonStyle(
                          overlayColor:
                              MaterialStatePropertyAll(Colors.transparent),
                        ),
                        child: Text(
                          'Forget Password?',
                          // AppLocalizations.of(context)!
                          //     .forgetpassword
                          //     .toString(),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: ThemeColors.fillColor,
                            fontSize: MySize.size12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MySize.size10),
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
                          // Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                          // p.signInWithEmailPassword(emailController.text,
                          //     passwordController.text, context);

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

                            // Authentication successful, navigate to the next screen
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen(userLocation: userLocation)));
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
                // Text(
                //   'or',
                //   // AppLocalizations.of(context)!.or.toString(),
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     color: ThemeColors.grey1,
                //     fontSize: MySize.size10,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
                // SizedBox(height: MySize.size20),
                // Consumer<LoginProvider>(
                //   builder: (context, p, child) => Platform.isIOS
                //       ? Padding(
                //           padding: Spacing.horizontal(MySize.size32),
                //           child: CustomSocialButton(
                //             text: 'login apple',
                //             // AppLocalizations.of(context)!
                //             //     .loginwithapple
                //             //     .toString(),
                //             backgroundColor: Colors.black,
                //             textColor: ThemeColors.bgColor,
                //             image: icApplelogo,
                //             radius: 30,
                //             onPressed: () async {
                //               // await p.signInWithApple(context);
                //             },
                //           ),
                //         )
                //       : Padding(
                //           padding: Spacing.horizontal(MySize.size32),
                //           child: CustomSocialButton(
                //             text: 'Sign in with Google',
                //             // AppLocalizations.of(context)!
                //             //     .loginwithgoogle
                //             //     .toString(),
                //             radius: 30,
                //             backgroundColor: ThemeColors.fillColor,
                //             textColor: ThemeColors.mainColor,
                //             image: icGoogleLogo,
                //             onPressed: () async {
                //               // await p.signInWithGoogle(context);
                //             },
                //           ),
                //         ),
                // ),
                // SizedBox(height: MySize.size15),
                // TextButton(
                //   onPressed: () async {},
                //   child: Text(
                //     'Continue as guest',
                //     // AppLocalizations.of(context)!.continueAsAGuest.toString(),
                //     textAlign: TextAlign.center,
                //     style: const TextStyle(
                //       color: ThemeColors.mainColor,
                //       fontSize: 12,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
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

  showCustomBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      backgroundColor: ThemeColors.black1,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              decoration: const BoxDecoration(
                color: ThemeColors.grey4,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        Spacing.fromLTRB(0, MySize.size40, 0, MySize.size50),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Reset password',
                        // AppLocalizations.of(context)!.resetPassword.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ThemeColors.fillColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: Spacing.horizontal(MySize.size32),
                    child: CustomTextField13(
                      controller: forgetPasswordController,
                      hintText: 'Enter your email',// AppLocalizations.of(context)!.email.toString(),
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      fillColor: ThemeColors.fillColor,
                      validator: (value) {
                        return CommonFunctions.validateTextField(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: Spacing.fromLTRB(
                        MySize.size32, MySize.size10, MySize.size32, MySize.size50),
                    child: Text(
                      'Forgot password',
                      // AppLocalizations.of(context)!
                      //     .forgetPasswordLink
                      //     .toString(),
                      style: TextStyle(
                        color: ThemeColors.grey1,
                        fontSize: MySize.size10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Consumer<LoginProvider>(
                    builder: (context, p, child) => Padding(
                      padding: Spacing.fromLTRB(
                          MySize.size32, 0, MySize.size32, MySize.size20),
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
                              text: 'Reset Password',
                              // AppLocalizations.of(context)!
                              //     .reset
                              //     .toString(),
                              onPressed: () async {
                                CommonFunctions.closeKeyboard(context);
                                if (forgetPasswordController.text.isNotEmpty) {
                                  // p.forgotPassword(
                                  //     forgetPasswordController.text, context);
                                  clearTextFormFields();
                                } else {
                                  CommonFunctions.flushBarErrorMessage(
                                    "Field is Required",
                                    context,
                                  );
                                }
                              },
                        // gradient: ThemeColors.myGradient,
                              backgroundColor: ThemeColors.mainColor,
                              textColor: ThemeColors.fillColor,
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  clearTextFormFields() {
    forgetPasswordController.clear();
    passwordController.clear();
    emailController.clear();
  }
}
