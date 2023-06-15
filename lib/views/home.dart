import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iomoo/views/animal_data.dart';
import '../components/card_animal.dart';
import '../utilities/typography.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 32),
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                // Define o alinhamento à esquerda
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Texto
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(bottom: 2.0),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: firestore
                          .collection('users')
                          .where('uid', isEqualTo: auth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error loading data: ${snapshot.error}',
                            textAlign: TextAlign.left,
                            style: AppTypography.heading,
                          );
                        } else if (snapshot.data!.docs.isEmpty) {
                          return const Text(
                            'No data available',
                            textAlign: TextAlign.left,
                            style: AppTypography.heading,
                          );
                        } else {
                          return Text(
                            'Olá, ${snapshot.data!.docs[0]['name']}',
                            textAlign: TextAlign.left,
                            style: AppTypography.heading,
                          );
                        }
                      },
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(bottom: 24.0),
                    child: const Text(
                      'Acompanhe todos os seus animais cadastrados, aqui!',
                      textAlign: TextAlign.left,
                      style: AppTypography.text,
                    ),
                  ),

                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: firestore
                        .collection('cattle')
                        .where('uidUser', isEqualTo: auth.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        var cattle = snapshot.data!.docs;
                        return Column(
                          children: cattle
                              .map((animal) => GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AnimalDataPage(id: animal['id'])),
                                    ), // Função de callback para lidar com o clique no card
                                    child: CardAnimal(
                                      name: animal['nickname'],
                                      id: animal['id'],
                                      heartRate: animal['heartRate'],
                                    ),
                                  ))
                              .toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
