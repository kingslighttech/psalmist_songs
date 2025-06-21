import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyA7Zgc1Wx-2BX7tRSgnGJ56zP5CbIj7XBA",
            authDomain: "music-template-mkrjdo.firebaseapp.com",
            projectId: "music-template-mkrjdo",
            storageBucket: "music-template-mkrjdo.appspot.com",
            messagingSenderId: "929055034701",
            appId: "1:929055034701:web:90f8147acbcd61e59c3b04",
            measurementId: "G-TDDZ51PH41"));
  } else {
    await Firebase.initializeApp();
  }
}
