import 'dart:math';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:template_app/utils/geoform/flutter_map_fast_markers/flutter_map_fast_markers.dart';

extension on CustomPoint {
  Offset toOffset() => Offset(x as double, y as double);
}

typedef FastMakerDrawer = void Function(
  Canvas canvas,
  Offset offset,
  MapState map,
);

class FastMarker {
  FastMarker({
    required this.point,
    this.width = 30.0,
    this.height = 30.0,
    required this.onDraw,
    this.onTap,
    this.show = true,
    AnchorPos? anchorPos,
  }) : anchor = Anchor.forPos(anchorPos, width, height);

  final LatLng point;
  final double width;
  final double height;
  final Anchor anchor;
  final FastMakerDrawer onDraw;
  final Function()? onTap;
  bool? show;
}

class MarkerLayerWidget extends StatelessWidget {
  const MarkerLayerWidget({Key? key, required this.options}) : super(key: key);

  final FastMarkersLayerOptions options;

  @override
  Widget build(BuildContext context) {
    final mapState = MapState.maybeOf(context)!;
    return FastMarkersLayer(options, mapState, mapState.onMoved);
  }
}

class FastMarkersLayer extends StatefulWidget {
  FastMarkersLayer(this.layerOptions, this.map, this.stream)
      : super(key: layerOptions.key);

  final FastMarkersLayerOptions layerOptions;
  final MapState map;
  final Stream<void> stream;

  @override
  State<FastMarkersLayer> createState() => _FastMarkersLayerState();
}

class _FastMarkersLayerState extends State<FastMarkersLayer> {
  _FastMarkersPainter? painter;

  @override
  void initState() {
    super.initState();
    painter = _FastMarkersPainter(
      widget.map,
      widget.layerOptions,
    );

    widget.layerOptions.tapStream?.stream.listen(
      (p) => painter!.onTap(p.relative),
    );
  }

  @override
  void didUpdateWidget(covariant FastMarkersLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    painter = _FastMarkersPainter(
      widget.map,
      widget.layerOptions,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: StreamBuilder(
        stream: widget.stream,
        builder: (BuildContext context, snapshot) {
          return CustomPaint(
            painter: painter,
            willChange: true,
          );
        },
      ),
    );
  }
}

class _FastMarkersPainter extends CustomPainter {
  _FastMarkersPainter(this.map, this.options) {
    _pxCache = generatePxCache();
  }

  final MapState map;
  final FastMarkersLayerOptions options;
  final List<MapEntry<Bounds, FastMarker>> markersBoundsCache = [];
  var _lastZoom = -1.0;

  /// List containing cached pixel positions of markers
  /// Should be discarded when zoom changes
  // Has a fixed length of markerOpts.markers.length - better performance:
  // https://stackoverflow.com/questions/15943890/is-there-a-performance-benefit-in-using-fixed-length-lists-in-dart
  var _pxCache = <CustomPoint>[];

  // Calling this every time markerOpts change should guarantee proper length
  List<CustomPoint> generatePxCache() => List.generate(
        options.markers.length,
        (i) => map.project(options.markers[i].point),
      );

  //late final markerignoreList=List<bool>.generate(this.options.markers.length,
  //       (int index) => true, growable: true);

  @override
  void paint(Canvas canvas, Size size) {
    final sameZoom = map.zoom == _lastZoom;

    const minimumZoom = 12.9;
    const maximumZoom = 16;
    const minZoomMarkerPercentage = 0.5;
    const slopeShowMarkers =
        (1 - (minZoomMarkerPercentage / 100)) / (maximumZoom - minimumZoom);
    const biasShowMarkers = 1 - (maximumZoom * slopeShowMarkers);

    var markerShowRate = slopeShowMarkers * map.zoom + biasShowMarkers;

    if (map.zoom < minimumZoom) {
      markerShowRate = minZoomMarkerPercentage / 100;
    }
    if (map.zoom >= 16) {
      markerShowRate = 1;
    }

    final showMarkersList = <int>[];
    final hideMarkersList = <int>[];
    var markerNumber = 0;

    for (var i = 0; i < options.markers.length; i++) {
      (options.markers[i].show ?? true)
          ? showMarkersList.add(i)
          : hideMarkersList.add(i);
    }

    //this if only works if:
    //1. there is a zoom change && zoom is high enough for showRate to change
    //2. there is a need to turn off markers (to avoid markers going crazy
    // mode on minimumZoomPercentage).
    if ((!sameZoom && map.zoom >= minimumZoom) ||
        markerShowRate < (showMarkersList.length / options.markers.length)) {
      while (
          markerShowRate > (showMarkersList.length / options.markers.length) &&
              (hideMarkersList.isNotEmpty)) {
        //this loop turns on markers
        markerNumber = Random().nextInt(hideMarkersList.length);
        options.markers[hideMarkersList[markerNumber]].show = true;
        showMarkersList.add(hideMarkersList[markerNumber]);
        hideMarkersList.removeAt(markerNumber);
      }

      while (
          markerShowRate < (showMarkersList.length / options.markers.length) &&
              (showMarkersList.isNotEmpty)) {
        //this loop turns off markers
        markerNumber = Random().nextInt(showMarkersList.length);
        options.markers[showMarkersList[markerNumber]].show = false;
        hideMarkersList.add(showMarkersList[markerNumber]);
        showMarkersList.removeAt(markerNumber);
      }
    }

    markersBoundsCache.clear();
    for (var i = 0; i < options.markers.length; i++) {
      if ((options.markers[i].show) ?? true) {
      } else {
        continue;
      } //skips the [i] marker

      final marker = options.markers[i];

      // Decide whether to use cached point or calculate it
      final pxPoint = sameZoom ? _pxCache[i] : map.project(marker.point);
      if (!sameZoom) {
        _pxCache[i] = pxPoint;
      }

      final topLeft = CustomPoint(
        pxPoint.x - marker.anchor.left,
        pxPoint.y - marker.anchor.top,
      );

      final bottomRight =
          CustomPoint(topLeft.x + marker.width, topLeft.y + marker.height);

      if (!map.pixelBounds
          .containsPartialBounds(Bounds(topLeft, bottomRight))) {
        continue;
      }

      final pos = topLeft - map.getPixelOrigin();

      // canvas.scale(18.2 / map.zoom, 18.2 / map.zoom);
      // canvas.scale(2.0);
      // canvas.scale(0.98);

      ///
      ///
      ///
      ///

      marker.onDraw(canvas, pos.toOffset(), map);

      markersBoundsCache.add(
        MapEntry(
          Bounds(pos, pos + CustomPoint(marker.width, marker.height)),
          marker,
        ),
      );
    }
    _lastZoom = map.zoom;
  }

  bool onTap(Offset? pos) {
    final marker = markersBoundsCache.reversed.firstWhereOrNull(
      (e) => e.key.contains(CustomPoint(pos!.dx, pos.dy)),
    );
    if (marker != null) {
      marker.value.onTap?.call();
      return false;
    } else {
      return true;
    }
  }

  @override
  bool shouldRepaint(covariant _FastMarkersPainter oldDelegate) {
    return true;
  }
}
