import 'dart:io';

import 'package:flutter_favorite_places_app/helper/db_helper.dart';
import 'package:flutter_favorite_places_app/models/place.dart';
import 'package:flutter_favorite_places_app/models/place_location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []);

  Future<void> fetchPlaces() async {
    final places = await DbHelper.getPlaces();
    state = places;
  }

  void addPlace({
    required String title,
    required File image,
    required PlaceLocation location,
  }) async {
    final newPlace = Place(
      title: title,
      image: image,
      location: location,
    );

    DbHelper.insert(newPlace);
    state = [newPlace, ...state];
  }

  void updatePlace({
    required String id,
    required String title,
    required File image,
    required PlaceLocation location,
  }) async {
    final updPlace = Place(
      id: id,
      title: title,
      image: image,
      location: location,
    );

    DbHelper.update(updPlace);
    state = state.map((place) => place.id == id ? updPlace : place).toList();
  }

  void removePlace(Place place) {
    state = state.where((p) => p != place).toList();
  }

  void revertPlaceRemoval(Place place, int index) {
    state = [...state]..insert(index, place);
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) => PlacesNotifier(),
);
