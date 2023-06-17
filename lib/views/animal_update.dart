import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iomoo/components/custom_button.dart';
import 'package:iomoo/components/input.dart';
import 'package:iomoo/components/modal_nfc.dart';
import 'package:iomoo/utilities/colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/animal.dart';
import '../utilities/icons.dart';
import '../utilities/typography.dart';

class AnimalUpdatePage extends StatefulWidget {
  final Animal animal;

  const AnimalUpdatePage({super.key, required this.animal});
  @override
  State<AnimalUpdatePage> createState() => _AnimalUpdatePageState();
}

class _AnimalUpdatePageState extends State<AnimalUpdatePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? gender;
  String? birthday;
  String? breed;
  String? id;
  String? idDevice;
  String? nickname;
  String? weight;

  List<String> sexos = ['Macho', 'Fêmea']; // Lista de sexos

  void updateAnimal(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final docSnapshot =
          await firestore.collection('cattle').where('id', isEqualTo: id).get();
      if (docSnapshot.docs.isNotEmpty) {
        await docSnapshot.docs.first.reference.update({
          'gender': gender!,
          'birthday': birthday!,
          'breed': breed!,
          'id': id!,
          'uidUser': auth.currentUser!.uid,
          'nickname': nickname!,
          'weight': weight!
        });
        Navigator.of(context).pushNamed('navbar');
        // O documento foi excluído com sucesso
      } else {
        // O documento não existe, trate o caso adequadamente
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final animal = ModalRoute.of(context)!.settings.arguments as Animal;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 72.0,
        backgroundColor: const Color(0xFF00DA30),
        title: Container(
          child: SvgPicture.asset('assets/images/logo-white-iomoo.svg',
              height: 26, width: 26),
        ),
        elevation: 0,
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 32),
            child:
                Icon(Icons.help_outline, color: Color(0xFF052C0E), size: 26.0),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 32),
        children: [
          Center(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Define o alinhamento à esquerda
              children: [
                //Texto
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(bottom: 2.0),
                  child: const Text(
                    'Atualizar Animal',
                    textAlign: TextAlign.left,
                    style: AppTypography.heading,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 32.0),
                  child: const Text(
                    'Informe todos os dados abaixo para atualizar o animal.',
                    textAlign: TextAlign.left,
                    style: AppTypography.text,
                  ),
                ),
                //Inputs
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Campo de identificação
                      Input(
                        label: 'Identificação do Animal*',
                        type: TextInputType.name,
                        icon: AppIcons.id,
                        hint: '#38724951',
                        value: (value) => id = value,
                        initvalue: animal.id,
                      ),

                      // Campo de apelido
                      Input(
                        label: 'Apelido do Animal',
                        type: TextInputType.name,
                        icon: AppIcons.nickname,
                        hint: 'Otis',
                        mandatory: false,
                        value: (value) => nickname = value,
                        initvalue: animal.nickname,
                      ),

                      // Campo Raça
                      const Text(
                        'Informe a raça do animal*',
                        style: AppTypography.label,
                      ),
                      SizedBox(height: 8),
                      Container(
                          width: 304,
                          height: 70,
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: firestore.collection('breeds').snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Text('Loading...');
                              } else {
                                List<DropdownMenuItem<String>> breedItems = [];
                                for (int i = 0;
                                    i < snapshot.data!.docs.length;
                                    i++) {
                                  DocumentSnapshot snap =
                                      snapshot.data!.docs[i];
                                  breedItems.add(
                                    DropdownMenuItem(
                                      value: "${snap['name']}",
                                      child: Text(
                                        snap['name'],
                                        style: AppTypography.inputHint,
                                      ),
                                    ),
                                  );
                                }

                                return DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    prefixIcon: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/breed.svg',
                                      ),
                                    ),
                                    hintText: animal.breed,
                                    hintStyle: AppTypography.inputHint,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(156),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(156),
                                    ),
                                  ),
                                  value: breed,
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        breed = newValue;
                                      });
                                    }
                                  },
                                  items: breedItems,
                                );
                              }
                            },
                          )),

                      // Campo de data de nascimento
                      Input(
                        label: 'Data de nascimento*',
                        type: TextInputType.datetime,
                        icon: AppIcons.calendar,
                        hint: 'dd/mm/aaaa',
                        value: (value) => birthday = value,
                        initvalue: animal.birthday,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Peso
                              const Text(
                                'Peso*',
                                style: AppTypography.label,
                              ),
                              // ignore: sized_box_for_whitespace
                              Container(
                                width: 130,
                                height: 70,
                                child: TextFormField(
                                  onSaved: (value) => weight = value!,
                                  initialValue: animal.weight,
                                  cursorColor: const Color(
                                      0xFF00DA30), // Define a cor do cursor
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(20),
                                    hintText: '124 kg',
                                    hintStyle: AppTypography.inputHint,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(156),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(156),
                                    ),
                                    suffix: Text(
                                      'kg',
                                      style: AppTypography.inputHint,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Campo Sexo
                              const Text(
                                'Sexo*',
                                style: AppTypography.label,
                              ),
                              // ignore: sized_box_for_whitespace
                              Container(
                                width: 150,
                                height: 70,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(18),
                                    hintText: animal.gender,
                                    hintStyle: AppTypography.inputHint,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(156),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(156),
                                    ),
                                  ),
                                  value: gender,
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        gender = newValue;
                                      });
                                    }
                                  },
                                  items: sexos.map((String sexo) {
                                    return DropdownMenuItem<String>(
                                      value: sexo,
                                      child: Text(sexo),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Container(
                        width: 304,
                        height: 65,
                        margin: const EdgeInsets.only(top: 40, bottom: 8),
                        child: CustomButton(
                          text: 'Atualizar Dados',
                          function: () => updateAnimal(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
