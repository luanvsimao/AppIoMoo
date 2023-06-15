import 'package:flutter/material.dart';
import 'package:iomoo/utilities/colors.dart';
import 'package:iomoo/views/user_login.dart';
import 'dart:async';
import '../utilities/icons.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserLoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: AppColors.primaryColor,
        body: Center(
          child: Stack(
            children: [
              // Imagem SVG que cobre toda a tela
              // SvgPicture.asset(
              //   'assets/images/background.svg',
              //   fit: BoxFit.cover,
              // ),
              // Imagem SVG no centro
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: AppIcons.iomoo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
