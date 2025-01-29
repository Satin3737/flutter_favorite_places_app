import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app/helper/maps_helper.dart';
import 'package:flutter_favorite_places_app/models/place_location.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _placeLocation;
  bool _isGettingLocation = false;

  void _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();

      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() => _isGettingLocation = true);
    final locationData = await location.getLocation();
    final latitude = locationData.latitude;
    final longitude = locationData.longitude;

    if (latitude == null || longitude == null) {
      setState(() => _isGettingLocation = false);
      return;
    }

    final url = MapsHelper.getMapApiUri(latitude, longitude);
    final response = await http.get(url);
    final resData = jsonDecode(response.body);
    final address = resData['results'][0]['formatted_address'];

    _placeLocation = PlaceLocation(
      latitude: latitude,
      longitude: longitude,
      address: address,
    );

    widget.onSelectLocation(_placeLocation!);

    setState(() => _isGettingLocation = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget previewContent = Text(
      'No location chosen',
      style: theme.textTheme.titleMedium!.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: theme.colorScheme.onSurface,
      ),
    );

    if (_placeLocation != null) {
      previewContent = Image.network(
        MapsHelper.getLocationImage(_placeLocation!),
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    if (_isGettingLocation) {
      previewContent = const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      spacing: 16,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.onSurface,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: previewContent,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 8,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
              onPressed: _isGettingLocation ? null : _getCurrentLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              onPressed: null,
            ),
          ],
        ),
      ],
    );
  }
}
