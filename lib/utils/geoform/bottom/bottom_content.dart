import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:template_app/l10n/l10n.dart';
import 'package:template_app/utils/geoform/bottom/bottom_widgets.dart';
import 'package:template_app/utils/geoform/geoform_markers.dart';

typedef GeoformBottomDisplayBuilder<U extends GeoformMarkerDatum> = Widget
    Function(BuildContext context, LatLng? currentPosition, U? selectedMarker);

class GeoformBottomInterface<U extends GeoformMarkerDatum>
    extends StatelessWidget {
  const GeoformBottomInterface({
    required this.title,
    required this.registerOnlyWithMarker,
    required this.selectedMarker,
    this.currentPosition,
    this.informationBuilder,
    this.onRegisterPressed,
    this.onActionPressed,
    this.actionTextController,
    this.actionActivated = false,
    Key? key,
  }) : super(key: key);

  final String title;
  final U? selectedMarker;
  final LatLng? currentPosition;

  final bool registerOnlyWithMarker;

  final GeoformBottomDisplayBuilder<U>? informationBuilder;

  final void Function()? onRegisterPressed;
  final void Function()? onActionPressed;

  final bool actionActivated;

  final TextEditingController? actionTextController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          if (informationBuilder != null)
            informationBuilder!(context, currentPosition, selectedMarker)
          else
            BottomInformation(selectedMarker: selectedMarker),
          if (actionActivated) ...[
            const SizedBox(height: 16),
            TextFormField(
              autocorrect: false,

              controller: actionTextController,
              // focusNode: widget.focusNode,
              // onChanged: widget.onChanged,
              // keyboardType: widget.isPhone ? TextInputType.phone : TextInputType.text,
              decoration: InputDecoration(
                // prefixText:
                //     (selectedMarker! as NVIMarkerDatum).geopointUnicode ?? '',
                //isDense: true,
                //hintText: '${(selectedMarker! as NVIMarkerDatum).geopointUnicode ?? ''}.a',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                labelText: "Editar",

                hintStyle: TextStyle(color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white70,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                errorMaxLines: 2,
              ),
              // TODO: paltita

              //   errorText: widget.initialValue.value.isEmpty
              //       ? null
              //       : widget.initialValue.invalid
              //           ? widget.errorText
              //           : null,
              // ),
              // initialValue: widget.initialValue.value,
            ),
            const SizedBox(height: 16),
          ] else
            ...[],
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: onActionPressed,
                  style: ElevatedButton.styleFrom(
                    animationDuration: const Duration(milliseconds: 300),
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    textStyle: GoogleFonts.rubik(fontSize: 18),
                  ),
                  child: Text(actionActivated ? 'Cancelar' : 'Adicional'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: onRegisterPressed,
                  style: ElevatedButton.styleFrom(
                    animationDuration: const Duration(milliseconds: 300),
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: GoogleFonts.rubik(fontSize: 18),
                  ),
                  child: Text('Registrar'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
