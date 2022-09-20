part of 'geoform_bloc.dart';

abstract class GeoformEvent extends Equatable {
  const GeoformEvent();
}

class ManualChanged extends GeoformEvent {
  const ManualChanged({this.manual});

  final bool? manual;

  @override
  List<Object?> get props => [manual];
}

class GeoformContextUpdated extends GeoformEvent {
  const GeoformContextUpdated({required this.context});

  final GeoformContext context;

  @override
  List<Object?> get props => [context];
}
