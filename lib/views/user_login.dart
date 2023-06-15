// ignore_for_file: use_build_context_synchronously, import_of_legacy_library_into_null_safe

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iomoo/components/input.dart';
import 'package:iomoo/utilities/colors.dart';
import 'package:iomoo/utilities/icons.dart';
import 'package:iomoo/utilities/typography.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/custom_button.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});
  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseAuth firestore = FirebaseAuth.instance;

  String email = '';
  String password = '';

  bool isObscured = true;

  void login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        await firestore.signInWithEmailAndPassword(
            email: email, password: password);
        Fluttertoast.showToast(msg: 'Login realizado com sucesso');
        Navigator.of(context).pushNamed('navbar');
      } catch (e) {
        if (e is FirebaseAuthException) {
          if (e.code == 'user-not-found') {
            Fluttertoast.showToast(msg: 'Email não encontrado');
          } else if (e.code == 'wrong-password') {
            Fluttertoast.showToast(msg: 'Senha incorreta');
          } else {
            Fluttertoast.showToast(msg: 'Erro de autenticação');
          }
        } else {
          Fluttertoast.showToast(msg: 'Erro ao autenticar');
        }
      }
    }
  }

  void needHelp() async {
    final phoneNumber = '+5517988134579';
    final message = 'Hello';

    FlutterOpenWhatsapp.sendSingleMessage(phoneNumber, message);
  }

  void resetPassword() async {
    final url = Uri.parse(
        'whatsapp://send?phone=5517988134579&text=Olá, preciso de uma nova senha!');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Não foi possível abrir o WhatsApp.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: ListView(
            children: [
              //Logo
              Container(
                padding: const EdgeInsets.only(top: 44.0, bottom: 64.0),
                child: SvgPicture.asset(
                  'assets/images/logo-iomoo.svg',
                  width: 180.0,
                  height: 52.0,
                  alignment: Alignment.topCenter,
                ),
              ),

              //Texto
              Container(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: const Text(
                  'Bem-vindo(a)',
                  style: AppTypography.headingLogin,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: const Text(
                  'Preencha os campos abaixo com os seus dados.',
                  textAlign: TextAlign.center,
                  style: AppTypography.body,
                ),
              ),

              //\formulário
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Input(
                      label: 'E-mail',
                      type: TextInputType.emailAddress,
                      icon: AppIcons.email,
                      hint: 'exemplo@gmail.com',
                      value: (value) => email = value,
                    ),

                    Input(
                      label: 'Senha',
                      type: TextInputType.visiblePassword,
                      icon: AppIcons.password,
                      hint: '********',
                      value: (value) => password = value,
                      isObscured: isObscured,
                    ),

                    CustomButton(
                      text: 'Entrar',
                      function: () => login(context),
                    ),

                    //"Esqueci minha senha"
                    Container(
                      height: 30,
                      margin: const EdgeInsets.only(top: 22.0),
                      child: TextButton(
                        // ignore: avoid_returning_null_for_void
                        onPressed: () => resetPassword(),
                        //needHelp(),
                        child: const Text(
                          'Esqueci minha senha',
                          style: AppTypography.body,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: 304,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        // ignore: avoid_returning_null_for_void
                        onPressed: () => needHelp(),
                        //needHelp(),
                        child: const Text(
                          'Preciso de ajuda',
                          style: AppTypography.extraBold,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      const Icon(
                        Icons.help_outline,
                        color: AppColors.primaryColor,
                        size: 14.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
