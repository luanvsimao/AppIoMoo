import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/card_notification.dart';
import '../utilities/typography.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 32),
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 0),
            alignment: Alignment.centerLeft,
            child: const Text(
              'Suas notificações',
              textAlign: TextAlign.left,
              style: AppTypography.heading,
            ),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: firestore
                .collection('notifications')
                .where('uidUser', isEqualTo: auth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var notifications = snapshot.data!.docs;
                return Column(
                  children: notifications
                      .map(
                        (notification) => CardNotification(
                          name: notification['nameCattle'],
                          id: notification['idCattle'],
                          status: notification['status'],
                          notificationOption: 'Status',
                          saw: notification['saw'],
                        ),
                      )
                      .toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
