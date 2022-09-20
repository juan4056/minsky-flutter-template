import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
// import 'package:template_app/home/bloc/home_bloc.dart';
import 'package:template_app/utils/geoform/animation/animation.dart';
import 'package:template_app/utils/geoform/animation/centroid.dart';
import 'package:template_app/utils/geoform/bottom/bottom.dart';
import 'package:template_app/utils/geoform/bottom/bottom_widgets.dart';
import 'package:template_app/utils/geoform/flutter_map_fast_markers/flutter_map_fast_markers.dart';
import 'package:template_app/utils/geoform/geoform.dart';
import 'package:template_app/utils/geoform/bloc/geoform_bloc.dart';
import 'package:template_app/utils/geoform/geoform_markers.dart';
import 'package:template_app/utils/geoform/view/overlay.dart';
import 'package:template_app/utils/geoform/view/ui.dart';
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';

class CachedTileProvider extends TileProvider {
  CachedTileProvider();

  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    return CachedNetworkImageProvider(
      getTileUrl(coords, options),
    );
  }
}

class GeoformView<T, U extends GeoformMarkerDatum> extends StatefulWidget {
  const GeoformView({
    Key? key,
    required this.formBuilder,
    required this.title,
    required this.markerBuilder,
    this.markerDrawer,
    this.records,
    this.markers,
    this.initialPosition,
    this.initialZoom,
    this.onRecordSelected,
    this.onMarkerSelected,
    this.registerOnlyWithMarker = false,
    this.followUserPositionAtStart = true,
    this.bottomInformationBuilder,
    this.updatePosition,
    this.updateZoom,
  }) : super(key: key);

  final GeoformFormBuilder<U> formBuilder;
  final bool followUserPositionAtStart;
  final bool registerOnlyWithMarker;
  final String title;

  final GeoformMarkerBuilder<U>? markerBuilder;
  final void Function(U marker)? onMarkerSelected;

  final Future<List<T>>? records;
  final List<U>? markers;
  final LatLng? initialPosition;
  final double? initialZoom;

  final GeoformMarkerDrawerBuilder<U>? markerDrawer;

  final void Function(T record)? onRecordSelected;

  final GeoformBottomDisplayBuilder? bottomInformationBuilder;

  // Functions to update pos and zoom
  final void Function(LatLng?)? updatePosition;
  final void Function(double?)? updateZoom;

  @override
  State<GeoformView> createState() => _GeoformViewState<T, U>();
}

class _GeoformViewState<T, U extends GeoformMarkerDatum>
    extends State<GeoformView> with SingleTickerProviderStateMixin {
  MapController mapController = MapController();
  LatLng mapPosition = LatLng(0, 0);
  late StreamSubscription<MapEvent> mapEventSubscription;
  late AnimationController animationController;

  List<FastMarker> _markers = [];
  final _tapStreamController = StreamController<TapPosition>();

  bool _isActionActivated = false;

  //VARIABLES FOR LIVE POSITION
  LocationData? _userLocation;
  String? serviceError;

  // TODO(all): Improve with better state management (probably usign Bloc pattern)
  U? _selectedMarker;

  late StreamSubscription _locationSubscription;

  final TextEditingController actionTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initLocationService();
    });
    mapEventSubscription = mapController.mapEventStream.listen((event) {
      setState(() {
        mapPosition = LatLng(event.center.latitude, event.center.longitude);
      });
    })
      ..pause();
    animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    setState(() {
      _markers = widget.markers
              ?.map<FastMarker>(_makerBuilderOrMarkerDrawer)
              .toList() ??
          [];
    });

    // TODO(all): Catch errors;
  }

  @override
  void dispose() {
    animationController.dispose();
    _locationSubscription.cancel();
    mapEventSubscription.cancel();
    super.dispose();
  }

  GeoformMarkerBuilder get _makerBuilderOrMarkerDrawer {
    if (widget.markerDrawer != null) {
      return defaultMarkerBuilder(
        customDraw: widget.markerDrawer,
        onTap: (datum) {
          setState(() {
            _selectedMarker = datum as U;
            widget.onMarkerSelected?.call(datum);
            actionTextController.clear();
          });
        },
      );
    }

    return widget.markerBuilder ??
        defaultMarkerBuilder(
          onTap: (datum) {
            setState(() {
              _selectedMarker = datum as U;
              widget.onMarkerSelected?.call(datum);
              actionTextController.clear();
            });
          },
        );
  }

  Future<void> initLocationService() async {
    LocationData locationData;
    final _locationService = Location();

    try {
      final serviceEnabled = await _locationService.serviceEnabled();

      if (serviceEnabled) {
        final permission = await _locationService.requestPermission();
        final _permission = permission == PermissionStatus.granted;

        if (_permission) {
          locationData = await _locationService.getLocation();
          setState(() {
            _userLocation = locationData;
          });
          if (widget.followUserPositionAtStart) {
            animatedMapMove(
              mapController,
              animationController,
              LatLng(
                _userLocation?.latitude ?? 0,
                _userLocation?.longitude ?? 0,
              ),
              18,
            );
          }

          _locationSubscription =
              _locationService.onLocationChanged.listen((locationData) async {
            if (mounted) {
              setState(() {
                _userLocation = locationData;
              });
            }
          });
        }
      } else {
        final serviceRequestResult = await _locationService.requestService();
        if (serviceRequestResult) {
          await initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        serviceError = e.message;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng? _currentLatLng;

    // Until currentLocation is initially updated, Widget can locate to 0, 0
    // by default or store previous location value to show.
    if (_userLocation != null) {
      _currentLatLng =
          LatLng(_userLocation!.latitude!, _userLocation!.longitude!);
    }

    final markers = <Marker>[
      Marker(
        width: 18,
        height: 18,
        point: _currentLatLng ?? LatLng(0, 0),
        builder: (ctx) => const DefaultLocationMarker(),
      ),
    ];

    return BlocConsumer<GeoformBloc, GeoformState>(
      listener: (context, state) {
        if (state.manual) {
          mapEventSubscription.resume();
        } else {
          mapEventSubscription.pause();
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                        onTap: (tapPosition, point) =>
                            _tapStreamController.add(tapPosition),
                        plugins: [FastMarkersPlugin()],
                        center: widget.initialPosition ?? LatLng(50, 50),
                        zoom: widget.initialZoom ?? 12,
                        maxZoom: 18.2,
                        minZoom: 4,
                        interactiveFlags: InteractiveFlag.doubleTapZoom |
                            InteractiveFlag.drag |
                            InteractiveFlag.pinchZoom |
                            InteractiveFlag.flingAnimation |
                            InteractiveFlag.pinchMove,
                        onPositionChanged: (position, hasGesture) {
                          final zoom = position.zoom;
                          final pos = position.center;
                          if (widget.updateZoom != null) {
                            widget.updateZoom!(zoom);
                          }
                          if (widget.updatePosition != null) {
                            widget.updatePosition!(pos);
                          }
                        }),
                    layers: [
                      FastMarkersLayerOptions(
                        markers: _markers,
                        tapStream: _tapStreamController,
                      ),
                      MarkerLayerOptions(
                        markers: markers,
                      ),
                      CircleLayerOptions()
                    ],
                    children: <Widget>[
                      TileLayerWidget(
                        options: TileLayerOptions(
                          urlTemplate:
                              'https://api.maptiler.com/maps/voyager/{z}/{x}/{y}@2x.png'
                              '?key=OvCbZy2nzfWql0vtrkbj',
                          //subdomains: ['a', 'b', 'c'],
                          tileProvider: CachedTileProvider(),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GeoformActionButton(
                            icon: const Icon(Icons.ads_click_rounded),
                            onPressed: () => context
                                .read<GeoformBloc>()
                                .add(ManualChanged(manual: !state.manual)),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GeoformActionButton(
                            onPressed: () {
                              animatedMapMove(
                                mapController,
                                animationController,
                                LatLng(
                                  _userLocation!.latitude!,
                                  _userLocation!.longitude!,
                                ),
                                18,
                              );
                              print(mapPosition);
                              print(_currentLatLng);
                            },
                            icon: const Icon(Icons.gps_fixed),
                          ),
                          const SizedBox(height: 8),
                          GeoformActionButton(
                            onPressed: _markers.isEmpty
                                ? null
                                : () {
                                    animatedMapMove(
                                      mapController,
                                      animationController,
                                      getCentroid(markers: _markers),
                                      13,
                                    );
                                    print(mapPosition);
                                    print(_currentLatLng);
                                  },
                            icon: const Icon(Icons.circle_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.manual)
                    const Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.pink,
                        size: 42,
                      ),
                    )
                  else
                    _selectedMarker == null
                        ? const SizedBox.shrink()
                        : GeoformMarkerOverlay(
                            mapController: mapController,
                            selectedMarker: _selectedMarker,
                            onTapOutside: () => setState(() {
                              _selectedMarker = null;
                              _isActionActivated = false;
                            }),
                          )
                ],
              ),
            ),
            Material(
              elevation: 8,
              child: GeoformBottomInterface<U>(
                actionActivated: _isActionActivated,
                currentPosition: _currentLatLng ?? LatLng(0, 0),
                selectedMarker: _selectedMarker,
                actionTextController: actionTextController,
                onRegisterPressed: !widget.registerOnlyWithMarker ||
                        _selectedMarker != null
                    ? () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => widget.formBuilder(
                              context,
                              GeoformContext(
                                currentPosition: _currentLatLng ?? LatLng(0, 0),
                                selectedMarker: _selectedMarker,
                                actionText:
                                    // '${(_selectedMarker! as NVIMarkerDatum).geopointUnicode}'
                                    actionTextController.text,
                              ),
                            ),
                          ),
                        ).then((value) => actionTextController.clear());
                      }
                    : null,
                onActionPressed:
                    !widget.registerOnlyWithMarker || _selectedMarker != null
                        ? () {
                            setState(() {
                              _isActionActivated = !_isActionActivated;
                            });
                            // showModalBottomSheet<void>(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return Container(
                            //       height: 300,
                            //       padding: const EdgeInsets.all(16),
                            //       child: Column(
                            //         crossAxisAlignment: CrossAxisAlignment.stretch,
                            //         children: [
                            //           Text(
                            //             widget.title,
                            //             style: const TextStyle(fontSize: 20),
                            //           ),
                            //           const SizedBox(height: 16),
                            //           if (widget.bottomInformationBuilder != null)
                            //             widget.bottomInformationBuilder!(
                            //               context,
                            //               _currentLatLng,
                            //               _selectedMarker,
                            //             )
                            //           else
                            //             _LatLongInfo(
                            //               currentPosition: _currentLatLng,
                            //             ),
                            //           const SizedBox(height: 16),
                            //           TextFormField(
                            //             autocorrect: false,
                            //             // focusNode: widget.focusNode,
                            //             // onChanged: widget.onChanged,
                            //             // keyboardType: widget.isPhone ? TextInputType.phone : TextInputType.text,
                            //             decoration: InputDecoration(
                            //               contentPadding:
                            //                   const EdgeInsets.symmetric(
                            //                 horizontal: 16,
                            //               ),
                            //               labelText: "Nuevo Unicode",
                            //               // hintText: 'Ingre',
                            //               hintStyle:
                            //                   TextStyle(color: Colors.grey[400]),
                            //               filled: true,
                            //               fillColor: Colors.white70,
                            //               border: const OutlineInputBorder(
                            //                 borderRadius: BorderRadius.all(
                            //                   Radius.circular(10),
                            //                 ),
                            //               ),
                            //               floatingLabelBehavior:
                            //                   FloatingLabelBehavior.always,
                            //               errorMaxLines: 2,
                            //             ),
                            //             // TODO: Que verguenzaaaaaa
                            //             initialValue:
                            //                 (_selectedMarker as NVIMarkerDatum?)
                            //                     ?.geopointUnicode,

                            //             //   errorText: widget.initialValue.value.isEmpty
                            //             //       ? null
                            //             //       : widget.initialValue.invalid
                            //             //           ? widget.errorText
                            //             //           : null,
                            //             // ),
                            //             // initialValue: widget.initialValue.value,
                            //           ),
                            //           const SizedBox(height: 16),
                            //           Expanded(
                            //             child: Row(
                            //               mainAxisAlignment: MainAxisAlignment.end,
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.end,
                            //               children: [
                            //                 Expanded(
                            //                   child: ElevatedButton(
                            //                     onPressed: () =>
                            //                         Navigator.pop(context),
                            //                     style: ElevatedButton.styleFrom(
                            //                       animationDuration: const Duration(
                            //                           milliseconds: 300),
                            //                       shadowColor: Colors.transparent,
                            //                       padding:
                            //                           const EdgeInsets.symmetric(
                            //                               vertical: 16),
                            //                       textStyle: GoogleFonts.rubik(
                            //                           fontSize: 18),
                            //                     ),
                            //                     child: Text("Registrar"),
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //     );
                            //   },
                            // );
                          }
                        : null,
                registerOnlyWithMarker: widget.registerOnlyWithMarker,
                title: widget.title,
                informationBuilder: widget.bottomInformationBuilder,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LatLongInfo extends StatelessWidget {
  const _LatLongInfo({Key? key, this.currentPosition}) : super(key: key);

  final LatLng? currentPosition;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: currentPosition == null
          ? const Center(child: CupertinoActivityIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Info(
                  title: "Latitud",
                  value: currentPosition!.latitude.toString(),
                ),
                const SizedBox(height: 8),
                Info(
                  title: "Longitud",
                  value: currentPosition!.longitude.toString(),
                ),
              ],
            ),
    );
  }
}
