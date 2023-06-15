import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> fetchDocumentsAndAddMarkers() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('cattle').get();

    setState(() {
      markers.clear();

      for (final DocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in snapshot.docs) {
        final data = documentSnapshot.data();
        if (data == null) {
          return;
        }
        final String documentId = documentSnapshot.id;
        final GeoPoint geoPoint = data['location'];
        final double latitude = geoPoint.latitude;
        final double longitude = geoPoint.longitude;
        final String title = data['nickname'] as String;
        final String description = '#' + data['nickname'];

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
    });
  }

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
