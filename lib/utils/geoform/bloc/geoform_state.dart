part of 'geoform_bloc.dart';

class GeoformState<U extends GeoformMarkerDatum> extends Equatable {
  const GeoformState._({
    this.context,
    this.manual = false,
  });

  GeoformState.initial()
      : this._(context: GeoformContext(currentPosition: LatLng(0.01, 0.01)));

  final bool manual;
  final GeoformContext? context;

  GeoformState copyWith({GeoformContext? context, bool? manual}) {
    return GeoformState._(
      context: context ?? this.context,
      manual: manual ?? this.manual,
    );
  }

  @override
  List<Object?> get props => [manual, context];
}
