import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:template_app/utils/geoform/geoform.dart';
import 'package:template_app/utils/geoform/geoform_markers.dart';

part 'geoform_event.dart';
part 'geoform_state.dart';

class GeoformBloc extends Bloc<GeoformEvent, GeoformState> {
  GeoformBloc() : super(GeoformState.initial()) {
    on<ManualChanged>(_onManualChanged);
    on<GeoformContextUpdated>(_onGeoformContextUpdated);
  }

  Future<void> _onManualChanged(
    ManualChanged event,
    Emitter<GeoformState> emit,
  ) async {
    emit(state.copyWith(manual: event.manual));
  }

  Future<void> _onGeoformContextUpdated(
    GeoformContextUpdated event,
    Emitter<GeoformState> emit,
  ) async {
    emit(state.copyWith(context: event.context));
  }
}
