import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:template_app/dashboard/form/form.dart';
import 'package:template_app/utils/geoform/geoform_markers.dart';

class MapForm extends StatefulWidget {
  const MapForm({Key? key, required this.position, required this.actionText})
      : super(key: key);

  final LatLng position;
  final String actionText;

  @override
  State<MapForm> createState() => _MapFormState();
}

class _MapFormState extends State<MapForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form')),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ProductFormView(),
      ),
    );
  }
}
