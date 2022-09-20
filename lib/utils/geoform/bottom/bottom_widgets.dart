import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:template_app/l10n/l10n.dart';
import 'package:template_app/utils/geoform/geoform_markers.dart';

class Info extends StatelessWidget {
  const Info({Key? key, required this.title, required this.value})
      : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$title: $value',
      style: GoogleFonts.openSans(fontSize: 14, color: Colors.grey),
    );
  }
}

class BottomInformation<U extends GeoformMarkerDatum> extends StatelessWidget {
  const BottomInformation({
    this.selectedMarker,
    this.currentPosition,
    Key? key,
  }) : super(key: key);

  final U? selectedMarker;
  final LatLng? currentPosition;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // selectedMarker.kind

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Info(
              title: "Position",
              value: selectedMarker?.position.toString() ?? '-',
            ),
            const Spacer(),
            Info(
              title: "Size (mtrs)",
              value: selectedMarker?.sizeMeters.toString() ?? '-',
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
