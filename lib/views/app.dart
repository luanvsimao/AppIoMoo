import 'package:flutter/material.dart';
import 'package:iomoo/views/splash.dart';
import '../models/animal.dart';
import 'animal_create.dart';
import 'animal_data.dart';
import 'animal_update.dart';
import 'user_login.dart';
import 'home.dart';
import 'navbar.dart';
import 'map.dart';
import 'notifications.dart';


class App extends StatelessWidget {
  
  const App({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        'user-login': (context) => const UserLoginPage(),
        'navbar': (context) => const NavBarPage(),
        'home': (context) => const HomePage(),
        'map': (context) => const MapPage(),
        'notifications': (context) => const NotificationsPage(),
        'animal-create': (context) => const AnimalCreatePage(),
        'animal-data': (context) => const AnimalDataPage(id: 'your_id_here'),
        'splash': (context) => const SplashPage(),
        'animal-update': (contex) => AnimalUpdatePage(animal: Animal(gender: '',
          birthday: '',
          breed: '',
          id: '',
          idDevice: '',
          uidUser: '',
          nickname: '',
          weight: '')),
      },
      initialRoute: 'splash',
    );
  }
}