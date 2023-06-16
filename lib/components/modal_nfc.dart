// ignore_for_file: sized_box_for_whitespace

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../utilities/colors.dart';

class ModalNFC extends StatefulWidget {
  final Function(String)
      onTagRead; // Função de callback para passar o valor lido

  const ModalNFC({Key? key, required this.onTagRead}) : super(key: key);

  @override
  State<ModalNFC> createState() => _ModalNFCState();
}

class _ModalNFCState extends State<ModalNFC> {
  Future<void> startTimer() async {
    await Future.delayed(const Duration(seconds: 1));
    widget.onTagRead(
        'z85rrlny60qd5at527ml3ki657ufri5b'); // Chama a função de callback com o valor padrão
    Navigator.of(context).pop(
        'z85rrlny60qd5at527ml3ki657ufri5b'); // Fecha o modal e retorna o valor padrão
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      child: Center(
        child: Column(
          children: [
            //Texto
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 10, bottom: 2.0),
              child: const Text(
                'Pronto para escanear',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 24,
                  wordSpacing: -2,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C1E10),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
              child: SvgPicture.asset(
                'assets/icons/nfc.svg',
                width: 120.0,
                height: 120.0,
                alignment: Alignment.topCenter,
              ),
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 24.0),
              width: 280,
              child: const Text(
                'Aproxime o celular da tag para cadastrar o dispositivo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Axiforma',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF0C1E10),
                ),
              ),
            ),

            Container(
              width: 304,
              height: 65,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.modalBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(72.0),
                    side: const BorderSide(
                        color: AppColors.primaryColor, width: 2.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50.0, vertical: 15.0),
                  elevation: 0,
                ),
                child: const Text(
                  'Finalizar Cadastro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Axiforma',
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF00DA30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
