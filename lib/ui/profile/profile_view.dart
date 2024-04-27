// ignore_for_file: use_build_context_synchronously, must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_pro/ui/profile/profile_provider.dart';

import '../../core/utils/common_functions.dart';
import '../../core/utils/mySize.dart';
import '../../core/utils/theme_helper.dart';
import '../custom_widgets/custom_buttons.dart';
import '../custom_widgets/custom_textfields.dart';
import '../custom_widgets/loader_view.dart';
import '../custom_widgets/scrollable_column.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final GlobalKey<FormState> _profileKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  @override
  void initState() {
    setInitialData();
    super.initState();
  }

  setInitialData() async {
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    emailController.text = data["email"] ?? "";
    passwordController.text = data["password"] ?? "";
    fullnameController.text = data["fullname"] ?? "";
    contactController.text = data["contact"] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: ThemeColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: ThemeColors.backgroundColor,
            foregroundColor: ThemeColors.fillColor,
            title: Text(
              'Profile',//AppLocalizations.of(context)!.profile.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ThemeColors.fillColor,
                fontSize: MySize.size16,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            elevation: 0.0,
            // backgroundColor: Colors.transparent,
            actions: [
              Consumer<ProfileProvider>(
                builder: (context, p, child) => TextButton(
                  onPressed: () {
                    p.setEditBtnClicked(!p.editBtnClicked);
                    CommonFunctions.closeKeyboard(context);
                  },
                  style: const ButtonStyle(
                    overlayColor: MaterialStatePropertyAll(
                      Colors.transparent,
                    ),
                  ),
                  child: Text(
                    'Edit',//AppLocalizations.of(context)!.edit.toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: ThemeColors.mainColor,
                      fontSize: MySize.size12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Consumer<ProfileProvider>(
              builder: (context, p, child) => ScrollableColumn(
                children: [
                  SizedBox(height: MySize.size10),
                  Form(
                    key: _profileKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: Spacing.horizontal(MySize.size32),
                          child: CustomTextField13(
                            controller: fullnameController,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.text,
                            hintText: 'Name',
                            // AppLocalizations.of(context)!
                            //     .fullName
                            //     .toString(),
                            fillColor: ThemeColors.fillColor,
                            readOnly: p.editBtnClicked,
                            validator: (value) {
                              return CommonFunctions.validateTextField(value);
                            },
                          ),
                        ),
                        SizedBox(height: MySize.size15),
                        Padding(
                          padding: Spacing.horizontal(MySize.size32),
                          child: CustomTextField13(
                            controller: emailController,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.text,
                            hintText:
                                'Email',//AppLocalizations.of(context)!.email.toString(),
                            fillColor: ThemeColors.fillColor,
                            readOnly: p.editBtnClicked,
                            validator: (value) {
                              return CommonFunctions.validateTextField(value);
                            },
                          ),
                        ),
                        SizedBox(height: MySize.size15),
                        Padding(
                          padding: Spacing.horizontal(MySize.size32),
                          child: CustomTextField13(
                            controller: contactController,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            keyboardType: TextInputType.text,
                            hintText:'Contact',
                            // AppLocalizations.of(context)!
                            //     .contact
                            //     .toString(),
                            fillColor: ThemeColors.fillColor,
                            readOnly: p.editBtnClicked,
                            validator: (value) {
                              return CommonFunctions.validateTextField(value);
                            },
                          ),
                        ),
                        SizedBox(height: MySize.size15),
                        Padding(
                          padding: Spacing.horizontal(MySize.size32),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: CustomTextField13(
                                  controller: passwordController,
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.text,
                                  hintText: 'Password',
                                  // AppLocalizations.of(context)!
                                  //     .password
                                  //     .toString(),
                                  fillColor: ThemeColors.fillColor,
                                  readOnly: p.editBtnClicked,
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
                                    return CommonFunctions.validateTextField(
                                        value);
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              Padding(
                                padding: Spacing.only(top: MySize.size0),
                                child: TextButton(
                                  onPressed: () async {
                                    // final obj = Provider.of<AppLanguage>(
                                    //     context,
                                    //     listen: false);
                                    // obj.changeShowLoaderValue(true);
                                   ///
                                    // try {
                                    //   await FirebaseAuth.instance
                                    //       .sendPasswordResetEmail(
                                    //           email: emailController.text)
                                    //       .then((value) {
                                    //     // obj.changeShowLoaderValue(false);
                                    //
                                    //     CommonFunctions.flushBarSuccessMessage(
                                    //         "Reset Password Email Sent Successfully",
                                    //         context);
                                    //   });
                                    // } on FirebaseAuthException catch (e) {
                                    //   // obj.changeShowLoaderValue(false);
                                    //
                                    //   print(e.code);
                                    //   CommonFunctions.flushBarErrorMessage(
                                    //       "Error Occured", context);
                                    // }
                                  },
                                  child: Text(
                                    'Reset',
                                    // AppLocalizations.of(context)!
                                    //     .reset
                                    //     .toString(),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: ThemeColors.mainColor,
                                      fontSize: MySize.size14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  p.editBtnClicked ? const SizedBox() : const Spacer(),
                  p.editBtnClicked
                      ? const SizedBox()
                      : Consumer<ProfileProvider>(
                          builder: (context, p, child) => Padding(
                            padding: Spacing.horizontal(MySize.size32),
                            child: CustomButton8(
                              text: 'Update',
                              // AppLocalizations.of(context)!
                              //     .update
                              //     .toString(),
                              backgroundColor: ThemeColors.mainColor,
                              textColor: ThemeColors.fillColor,
                              onPressed: () async {
                                // final obj = Provider.of<AppLanguage>(context,
                                //     listen: false);
                                // obj.changeShowLoaderValue(true);

                              ///
                              //   FirebaseAuth auth = FirebaseAuth.instance;
                              //   FirebaseFirestore.instance
                              //       .collection("User")
                              //       .doc(auth.currentUser!.uid)
                              //       .update(
                              //     {
                              //       "id": auth.currentUser!.uid,
                              //       "fullname": fullnameController.text,
                              //       // "email": emailController.text,
                              //       "contact": contactController.text,
                              //       "password": passwordController.text,
                              //     },
                              //   ).then((value) {
                              //     // obj.changeShowLoaderValue(false);
                              //     CommonFunctions.flushBarSuccessMessage(
                              //         "Profile Updated Successfully", context);
                              //     p.setEditBtnClicked(!p.editBtnClicked);
                              //   }).onError((error, stackTrace) {
                              //     // obj.changeShowLoaderValue(false);
                              //     CommonFunctions.flushBarSuccessMessage(
                              //         "Error Occurred", context);
                              //     p.setEditBtnClicked(!p.editBtnClicked);
                              //   });
                              },
                            ),
                          ),
                        ),
                  p.editBtnClicked
                      ? const SizedBox()
                      : SizedBox(height: MySize.size30),
                ],
              ),
            ),
          ),
        ),
        Consumer<ProfileProvider>(
          builder: (context, p, child) =>
              p.showLoader ? const LoaderView() : Container(),
        ),
      ],
    );
  }
}
