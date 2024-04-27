import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_pro/core/providers/loading_provider.dart';
import 'package:traffic_pro/providers/event_provider.dart';
import 'package:traffic_pro/ui/auth/login/login_provider.dart';
import 'package:traffic_pro/ui/profile/profile_provider.dart';
import 'package:traffic_pro/ui/splash_screen.dart';

import 'core/utils/theme_helper.dart';

// This is the main function, The App starts from here
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // here we initiliaze firebase in our app.
  await Firebase.initializeApp();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Multiproviders are a part of provider which we use for state management
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => LoadingProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => EventTypeProvider()),


      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: ThemeColors.mainColor),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

