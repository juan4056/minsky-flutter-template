import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:template_app/utils/geoform/bottom/bottom.dart';
import 'package:template_app/utils/geoform/bloc/geoform_bloc.dart';
import 'package:template_app/utils/geoform/geoform_markers.dart';
import 'package:template_app/utils/geoform/view/view.dart';

class GeoformContext {
  // <U extends GeoformMarkerDatum>
  GeoformContext({
    required this.currentPosition,
    this.selectedMarker,
    this.extra,
    this.actionText,
  });

  final LatLng currentPosition;
  final GeoformMarkerDatum? selectedMarker;
  final Map<String, dynamic>? extra;

  final String?
      actionText; // That exists only in the context of the NVI application.
}

typedef GeoformFormBuilder<U extends GeoformMarkerDatum> = Widget Function(
  BuildContext context,
  GeoformContext geoformContext,
);

class Geoform<T, U extends GeoformMarkerDatum> extends StatelessWidget {
  const Geoform({
    Key? key,
    required this.formBuilder,
    required this.title,
    this.records, // Future<List<T>>.value([]),
    this.markers,
    this.markerBuilder, // defaultMarkerBuilder<U>(),
    this.initialPosition,
    this.initialZoom,
    this.markerDrawerBuilder,
    this.onRecordSelected,
    this.onMarkerSelected,
    this.registerOnlyWithMarker = false,
    this.followUserPositionAtStart = true,
    this.bottomInformationBuilder,
    this.updatePosition,
    this.updateZoom,
  }) : super(key: key);

  final String title;
  final GeoformFormBuilder<U> formBuilder;
  final bool registerOnlyWithMarker;
  final bool followUserPositionAtStart;

  final GeoformMarkerBuilder<U>? markerBuilder;
  final GeoformMarkerDrawerBuilder<U>? markerDrawerBuilder;
  final void Function(U marker)? onMarkerSelected;

  final Future<List<T>>? records;
  final List<U>? markers;
  final void Function(T record)? onRecordSelected;

  final LatLng? initialPosition;
  final double? initialZoom;

  final GeoformBottomDisplayBuilder? bottomInformationBuilder;

  // Functions to update pos and zoom
  final void Function(LatLng?)? updatePosition;
  final void Function(double?)? updateZoom;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GeoformBloc(),
      child: GeoformView<T, U>(
        formBuilder: formBuilder,
        title: title,
        markerBuilder: markerBuilder,
        records: records,
        markers: markers,
        initialPosition: initialPosition,
        initialZoom: initialZoom,
        markerDrawer: markerDrawerBuilder,
        onRecordSelected: onRecordSelected,
        onMarkerSelected: onMarkerSelected,
        registerOnlyWithMarker: registerOnlyWithMarker,
        followUserPositionAtStart: followUserPositionAtStart,
        bottomInformationBuilder: bottomInformationBuilder,
        updatePosition: updatePosition,
        updateZoom: updateZoom,
      ),
    );
  }
}
