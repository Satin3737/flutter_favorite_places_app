import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app/models/place.dart';

class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Center(
        child: Text(place.title,
            style: theme.textTheme.titleMedium!.copyWith(
              fontSize: 24,
              color: theme.colorScheme.onSurface,
            )),
      ),
    );
  }
}
