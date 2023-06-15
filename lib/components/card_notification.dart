// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

import '../utilities/colors.dart';

// ignore: must_be_immutable
class CardNotification extends StatefulWidget {
  final String name;
  final String id;
  int heartRate;
  String status;
  String notificationOption;
  bool saw;

  CardNotification({
    Key? key,
    required this.name,
    required this.id,
    this.heartRate = 0,
    this.status = '',
    this.notificationOption = 'Status',
    this.saw = false,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CardNotification createState() => _CardNotification();
}

class _CardNotification extends State<CardNotification> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(32,32,32,12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
          color: widget.saw ? const Color(0xFFECECEC) : AppColors.primaryColor.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.saw ? Colors.transparent : AppColors.primaryColor,
            width: 2.0, // Largura da borda
          )),
      child: GestureDetector(
        onTap: () => setState(() {
          widget.saw = true;
        }), // Função de callback para lidar com o clique no card

        child: IntrinsicHeight(
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Verificamos uma alteração de estresse',
                      style: TextStyle(
                          fontFamily: 'Axiforma',
                          color: Color(0xFF0C1E10),
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      width: double.infinity,
                      child: const Text(
                        'há 1min',
                        style: TextStyle(
                          fontFamily: 'Axiforma',
                          color: Color.fromARGB(146, 12, 30, 16),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    flex: 0,
                    child: Container(
                        alignment: Alignment.centerLeft,
                        width: 32,
                        height: 32,
                        child: const CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/cow-avatar.png'),
                          backgroundColor: Color(0xFFFCFCFC),
                        )),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    flex: 0,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.name,
                        style: const TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0C1E10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.id,
                        style: const TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 16,
                          color: Color(0xFF0C1E10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(70, 244, 49, 49),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Center(
                        child: Text(
                          'estressado',
                          style: TextStyle(
                            color: Color(0xffF43131),
                            fontFamily: 'Axiforma',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
