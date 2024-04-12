import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if(kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyD_NxfQmk_zhTUGhhUwV3TWCr8AaOkgId8",
            authDomain: "farmereats-a0ccc.firebaseapp.com",
            projectId: "farmereats-a0ccc",
            storageBucket: "farmereats-a0ccc.appspot.com",
            messagingSenderId: "746385504918",
            appId: "1:746385504918:web:fe61a87edc2360002ba0b7",
            measurementId: "G-E3YG4TJEKW"));
  }else{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farmer Eats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: IntroScreen(),
    );
  }
}
