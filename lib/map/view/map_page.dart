import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:template_app/map/view/map_form.dart';
import 'package:template_app/utils/geoform/geoform.dart';
import 'package:template_app/utils/geoform/geoform_markers.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Geoform')),
      body: Geoform(
        title: 'Mapa Geoform',
        initialPosition: LatLng(-16.40904025, -71.509028501),
        initialZoom: 18,
        formBuilder: (context, metadata) {
          return MapForm(
            position: metadata.currentPosition,
            actionText: metadata.actionText ?? '',
          );
        },
      ),
    );
  }
}
