import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms and Conditions',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Welcome to Traffic Pro! By using our app, you agree to comply with and be bound by the following terms and conditions of use. Please read these terms and conditions carefully before using our app.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. The content of the pages of this app is for your general information and use only. It is subject to change without notice.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '2. Your use of any information or materials on this app is entirely at your own risk, for which we shall not be liable. It shall be your own responsibility to ensure that any products, services, or information available through this app meet your specific requirements.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '3. This app contains material which is owned by or licensed to us. This material includes, but is not limited to, the design, layout, look, appearance, and graphics. Reproduction is prohibited other than in accordance with the copyright notice.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '4. All trademarks reproduced in this app, which are not the property of, or licensed to the operator, are acknowledged on the app.',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '5. Unauthorized use of this app may give rise to a claim for damages and/or be a criminal offense.',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 24.0),
              Text(
                'By using the Traffic Pro app, you signify your acceptance of these terms and conditions. If you do not agree to these terms, please do not use our app. Your continued use of the app following the posting of changes to these terms will be deemed your acceptance of those changes.',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
