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
  TextEditingController fullnameController = TextEditingController();

  @override
  void initState() {
    setInitialData();
    super.initState();
  }

  setInitialData() async {
    var data = await FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    emailController.text = data["email"] ?? "";
    // passwordController.text = data["password"] ?? "";
    fullnameController.text = data["name"] ?? "";
    // contactController.text = data["contact"] ?? "";
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
                            title: 'Name',
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
                            title: 'Email',
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
