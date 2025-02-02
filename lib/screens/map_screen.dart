import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app/helper/maps_helper.dart';
import 'package:flutter_favorite_places_app/models/place_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = MapsHelper.defaultLocation,
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _pickedLocation;

  @override
  void initState() {
    super.initState();
    _pickedLocation = LatLng(
      widget.location.latitude,
      widget.location.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSelecting = widget.isSelecting;

    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(isSelecting ? 'Select on Map' : 'Your Location'),
        actions: [
          if (isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => Navigator.of(context).pop(_pickedLocation),
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _pickedLocation,
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('m1'),
            position: _pickedLocation,
          ),
        },
        onTap: (latLng) {
          if (!isSelecting) return;
          setState(() => _pickedLocation = latLng);
        },
      ),
    );
  }
}
