import 'dart:io';

import 'package:flutter_favorite_places_app/helper/db_helper.dart';
import 'package:flutter_favorite_places_app/models/place.dart';
import 'package:flutter_favorite_places_app/models/place_location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

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
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName.png');

    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: location,
    );

    await DbHelper.insert(newPlace);
    state = [newPlace, ...state];
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
