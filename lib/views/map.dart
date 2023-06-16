import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-20.792893797175797, -49.39992803068541),
    zoom: 17,
  );

  final Set<Marker> markers = {}; // Conjunto de marcadores no mapa
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> fetchDocumentsAndAddMarkers() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('cattle')
        .where('uidUser', isEqualTo: auth.currentUser!.uid)
        .get();

    setState(() {
      markers.clear();

      for (final DocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in snapshot.docs) {
        final data = documentSnapshot.data();
        final String documentId = documentSnapshot.id;

        if (data != null && data['location'] != null) {
          final GeoPoint geoPoint = data['location'] as GeoPoint;
          final double latitude = geoPoint.latitude;
          final double longitude = geoPoint.longitude;
          final String title = data['nickname'] as String;
          final String description = '#' + data['id'];

          markers.add(
            Marker(
              markerId: MarkerId(documentId),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: title,
                snippet: description,
              ),
            ),
          );
        }
      }
    });
  }

  /*_carregaMarcadores() {
    Marker marcadorSonda = Marker(
      markerId: MarkerId("marcador-sonda"),
      position: LatLng(-20.792893797175797, -49.39992803068541),
      infoWindow: InfoWindow(
        title: "Sonda",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    Marker marcadorMax = Marker(
      markerId: MarkerId("marcador-max"),
      position: LatLng(-19.792893797175797, -47.39992803068541),
      infoWindow: InfoWindow(
        title: "Max",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      markers.add(marcadorSonda);
      markers.add(marcadorMax);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          fetchDocumentsAndAddMarkers(); // Adicionar o marcador quando o mapa for criado
        },
        markers:
            markers, // Passar o conjunto de marcadores para o GoogleMap widget
      ),
    );
  }
}
