// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iomoo/utilities/colors.dart';
import 'package:iomoo/utilities/typography.dart';

import '../utilities/icons.dart';

class Notifications {
  String idCattle;

  String nameCattle;

  String status;

  DateTime time;

  String uidUser;

  Notifications(
      this.idCattle, this.nameCattle, this.status, this.time, this.uidUser);

  Map<String, dynamic> toMap() {
    return {
      'idCattle': idCattle,
      'nameCattle': nameCattle,
      'status': status,
      'time': time,
      'uidUser': uidUser,
    };
  }
}

class CardAnimal extends StatefulWidget {
  final String name;
  final String id;
  final int heartRate;

  const CardAnimal({
    Key? key,
    required this.name,
    required this.id,
    required this.heartRate,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CardAnimal createState() => _CardAnimal();
}

class _CardAnimal extends State<CardAnimal> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool notificationAdded = false;

  @override
  void initState() {
    super.initState();
    checkAndAddNotification();
  }

  void checkAndAddNotification() async {
    final String status = getStatus();

    final Notifications notification = Notifications(
      widget.id,
      widget.name,
      status,
      DateTime.now(),
      auth.currentUser!.uid,
    );

    if (status == 'Estressado' && !notificationAdded) {
      final QuerySnapshot querySnapshot = await firestore
          .collection('notifications')
          .where('idCattle', isEqualTo: widget.id)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Não há documentos com o mesmo idCattle, então podemos criar um novo
        await firestore.collection('notifications').add(notification.toMap());
      } else {
        // Já existe um documento com o mesmo idCattle
        // Faça o tratamento adequado, como exibir uma mensagem de erro ou atualizar o documento existente
        // Aqui, estou apenas imprimindo uma mensagem
        print('Já existe um documento com o mesmo idCattle');
      }

      setState(() {
        notificationAdded = true;
      });
    }
  }

  String getStatus() {
    if (widget.heartRate < 80) {
      return 'Calmo';
    } else if (widget.heartRate >= 80 && widget.heartRate <= 100) {
      return 'Agitado';
    } else {
      return 'Estressado';
    }
  }

  Color getStatusColor() {
    if (widget.heartRate < 80) {
      return AppColors.calmState;
    } else if (widget.heartRate >= 80 && widget.heartRate <= 100) {
      return AppColors.agitatedState;
    } else {
      return AppColors.stressedState;
    }
  }

  void deleteAnimal(String id, bool confirmDelete) async {
    if (confirmDelete) {
      try {
        final docSnapshot = await firestore
            .collection('cattle')
            .where('id', isEqualTo: id)
            .get();
        if (docSnapshot.docs.isNotEmpty) {
          await docSnapshot.docs.first.reference.delete();
        } else {
          // O documento não existe, trate o caso adequadamente
        }
      } catch (e) {
        // Ocorreu um erro ao excluir o documento, trate o erro adequadamente
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String status = getStatus();
    final Color color = getStatusColor();

    if (status == 'Estressado') {
      final Notifications notification = Notifications(
        widget.id,
        widget.name,
        status,
        DateTime.now(),
        auth.currentUser!.uid,
      );

      // Adicione a notificação ao banco de dados
      firestore.collection('notifications').add(notification.toMap());
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: (Container(
        margin: const EdgeInsets.only(left: 6, right: 6),
        color: AppColors.cardBackground,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        height: 120,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  width: 66,
                  height: 66,
                  child: CircleAvatar(
                    backgroundColor: AppColors.avatar.withOpacity(0.10),
                    backgroundImage:
                        const AssetImage('assets/images/cow-avatar.png'),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 30,
                      child: Text(
                        widget.name,
                        style: AppTypography.headingCard,
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      height: 20,
                      child: Opacity(
                        opacity: 0.3,
                        child: Text(
                          '#${widget.id}',
                          style: AppTypography.body,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(94),
                    color: color.withOpacity(0.3),
                  ),
                  margin: const EdgeInsets.only(right: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  alignment: Alignment.center,
                  child: Text(
                    status,
                    style: TextStyle(
                      fontFamily: 'Axiforma',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      AppIcons.heart,
                      const SizedBox(
                          width: 10), // espaço entre o ícone e o texto
                      Text(
                        '${widget.heartRate} BPM',
                        style: const TextStyle(
                          fontFamily: 'Axiforma',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
