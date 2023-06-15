import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iomoo/utilities/colors.dart';

import '../utilities/icons.dart';
import 'animal_create.dart';
import 'home.dart';
import 'map.dart';
import 'notifications.dart';

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key});
  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int indexIcons = 1;
  int indexTela = 1;
  var color = AppColors.text;
  bool home = true;

  final screens = [
    const MapPage(),
    const HomePage(),
    const NotificationsPage(),
    const AnimalCreatePage()
  ];

  List<SvgPicture> itens = [AppIcons.map, AppIcons.add, AppIcons.notifications];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          backgroundColor: const Color(0xFF00DA30),
          title: SvgPicture.asset('assets/images/logo-white-iomoo.svg',
              height: 26, width: 26),
          actions: const <Widget>[
            Icon(Icons.help_outline, color: Color(0xFF052C0E), size: 26.0),
          ],
        ),
        body: screens[indexTela],
        bottomNavigationBar: CurvedNavigationBar(
          key: navigationKey,
          height: 64,
          index: indexIcons,
          items: itens,
          backgroundColor: Colors.transparent,
          color: AppColors.primaryColor,
          //buttonBackgroundColor: color,
          animationCurve: Curves.easeInOut,
          onTap: (index) {
            indexIcons = index;
            indexTela = index;

            setState(() {
              if (index == 1) {
                if (itens[1] == AppIcons.add) {
                  indexTela = 3;
                  itens[1] = AppIcons.home;
                } else {
                  itens[1] = AppIcons.add;
                }
              } else {
                itens[1] = AppIcons.home;
              }
            });
          },
        ),
      ),
    );
  }
}
