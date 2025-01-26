import 'package:flutter_favorite_places_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super(const []);

  void addPlace(Place place) {
    state = [place, ...state];
  }

  void removePlace(Place place) {
    state = state.where((p) => p != place).toList();
  }

  void revertPlaceRemoval(Place place, int index) {
    state = state..insert(index, place);
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<Place>>(
  (ref) => PlacesNotifier(),
);
