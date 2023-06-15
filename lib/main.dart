
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'views/app.dart';
import 'package:firebase_core/firebase_core.dart';

const firebaseConfig = FirebaseOptions(
  apiKey: "AIzaSyDhP_ehFbRRkIDbzmzfWAJC-F1w4tHaO9o",
  authDomain: "iomoo-d58cc.firebaseapp.com",
  projectId: "iomoo-d58cc",
  storageBucket: "iomoo-d58cc.appspot.com",
  messagingSenderId: "191768562985",
  appId: "1:191768562985:web:bc28b0adc88949e8fa7b38",
  measurementId: "G-Z6QLR32JHP"
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseConfig);
  runApp(App());
}
