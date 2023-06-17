// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iomoo/utilities/typography.dart';

import '../components/cardanimal_data.dart';
import '../components/custom_button.dart';
import '../models/animal.dart';

class AnimalDataPage extends StatefulWidget {
  final String id;

  const AnimalDataPage({Key? key, required this.id}) : super(key: key);

  @override
  _AnimalDataPageState createState() => _AnimalDataPageState();
}

class _AnimalDataPageState extends State<AnimalDataPage> {
  late int tab = 0;
  Animal animalData = Animal(
    gender: 'gender',
    birthday: 'birthday',
    breed: 'breed',
    id: 'id',
    idDevice: 'idDevice',
    uidUser: 'uidUser',
    nickname: 'nickname',
    weight: 'weight',
  );

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchAnimalData();
  }

  Future<void> fetchAnimalData() async {
    final snapshot = await firestore
        .collection('cattle')
        .where('id', isEqualTo: widget.id)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final document = snapshot.docs.first;
      // ignore: unnecessary_cast
      final animal = document.data() as Map<String, dynamic>;

      setState(() {
        animalData = Animal(
          gender: animal['gender'],
          birthday: animal['birthday'],
          breed: animal['breed'],
          id: animal['id'],
          idDevice: animal['idDevice'],
          uidUser: animal['uidUser'],
          nickname: animal['nickname'],
          weight: animal['weight'],
          location: animal['location'],
        );
      });
    }
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-20.792893797175797, -49.39992803068541),
    zoom: 17,
  );

  final Set<Marker> markers = {}; // Conjunto de marcadores no mapa

  Future<void> fetchDocumentsAndAddMarkers() async {
    setState(() {
      markers.clear();

      final GeoPoint? geoPoint = animalData.location;
      final double latitude = geoPoint!.latitude;
      final double longitude = geoPoint.longitude;
      final String title = animalData.nickname;
      final String description = '#' + animalData.id;

      markers.add(
        Marker(
          markerId: MarkerId(animalData.id),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: title,
            snippet: description,
          ),
        ),
      );
    });
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
          Navigator.of(context).pushNamed('navbar');
          // O documento foi excluído com sucesso
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
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          toolbarHeight: 72.0,
          backgroundColor: const Color(0xFF00DA30),
          title: Container(
            child: SvgPicture.asset('assets/images/logo-white-iomoo.svg',
                height: 26, width: 26),
          ),
          actions: const <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 32),
              child: Icon(Icons.help_outline,
                  color: Color(0xFF052C0E), size: 26.0),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 25),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('cattle')
                              .where('id', isEqualTo: widget.id)
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('Error fetching data'),
                              );
                            }

                            if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              final document = snapshot.data!.docs.first;
                              final animal =
                                  document.data() as Map<String, dynamic>;

                              return CardAnimalData(
                                name: animal['nickname'],
                                id: animal['id'],
                                heartRate: animal['heartRate'],
                              );
                            }

                            return Center(
                              child: Text('No data available, id:$widget.id'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 25.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00DA30),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => {tab = 0}),
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(right: 5),
                                  decoration: BoxDecoration(
                                    color: tab == 0
                                        ? const Color(0xFF0C1E10)
                                            .withOpacity(0.4)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Text(
                                    'Dados',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => {tab = 1}),
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(left: 5),
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: tab == 1
                                        ? const Color(0xFF0C1E10)
                                            .withOpacity(0.4)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Text(
                                    'Localização',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (tab == 0)
                        Expanded(
                          child: ListView(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F0F0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                margin: const EdgeInsets.only(bottom: 25.0),
                                height: 50.0,
                                child: Center(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: SvgPicture.asset(
                                          'assets/icons/id.svg',
                                          height: 16.0,
                                          width: 16.0,
                                        ),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        'Número do brinco',
                                        style: AppTypography.inputHint,
                                      ),
                                      const SizedBox(width: 10.0),
                                      Text(
                                        '#${widget.id}',
                                        style: AppTypography.informationAnimal,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 17.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/nickname.svg',
                                          width: 16,
                                          height: 16,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          'Apelido do Animal',
                                          style: AppTypography.inputHint,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6.0),
                                    Text(
                                      animalData.nickname,
                                      style: AppTypography.informationAnimal,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 17.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/breed.svg',
                                          width: 16,
                                          height: 16,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          'Raça',
                                          style: AppTypography.inputHint,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6.0),
                                    Text(
                                      animalData.breed,
                                      style: AppTypography.informationAnimal,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 17.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/calendar.svg',
                                          width: 16,
                                          height: 16,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          'Data de nascimento',
                                          style: AppTypography.inputHint,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6.0),
                                    Text(
                                      animalData.birthday,
                                      style: AppTypography.informationAnimal,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 17.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Peso',
                                          style: AppTypography.inputHint,
                                        ),
                                        const SizedBox(height: 6.0),
                                        Text(
                                          animalData.weight + ' kg',
                                          style:
                                              AppTypography.informationAnimal,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 25.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sexo',
                                          style: AppTypography.inputHint,
                                        ),
                                        const SizedBox(height: 6.0),
                                        Text(
                                          animalData.gender,
                                          style:
                                              AppTypography.informationAnimal,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Id do dispositivo:',
                                        style: AppTypography.idDevice,
                                      ),
                                      const SizedBox(height: 6.0),
                                      SizedBox(
                                        width: 210,
                                        child: Text(
                                          animalData.idDevice,
                                          style: AppTypography.inputHint,
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 15.0),
                                  SvgPicture.asset(
                                    'assets/images/idDevice.svg',
                                    width: 70,
                                    height: 70,
                                  ),
                                ],
                              ),
                              Container(
                                width: 304,
                                height: 65,
                                margin:
                                    const EdgeInsets.only(top: 48, bottom: 12),
                                child: CustomButton(
                                  text: 'Editar',
                                  function: () => Navigator.of(context)
                                      .pushNamed('animal-update',
                                          arguments: animalData),
                                ),
                              ),
                              Container(
                                width: 304,
                                height: 65,
                                margin:
                                    const EdgeInsets.only(top: 12, bottom: 40),
                                child: CustomButton(
                                  text: 'Excluir Animal',
                                  function: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Confirmação'),
                                        content: const Text(
                                            'Tem certeza de que deseja excluir este animal?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              deleteAnimal(widget.id,
                                                  true); // Excluir o animal
                                              Navigator.pop(
                                                  context); // Fechar o Dialog
                                            },
                                            child: const Text('Sim'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Fechar o Dialog
                                            },
                                            child: const Text('Cancelar'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (tab == 1)
                        Expanded(
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: _kGooglePlex,
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                              fetchDocumentsAndAddMarkers(); // Adicionar o marcador quando o mapa for criado
                            },
                            markers:
                                markers, // Passar o conjunto de marcadores para o GoogleMap widget
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
