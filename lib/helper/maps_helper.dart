import 'package:flutter_favorite_places_app/models/place_location.dart';

class MapsHelper {
  static final String _googleMapsApiKey = 'key';

  static const PlaceLocation defaultLocation = PlaceLocation(
    latitude: 37.422,
    longitude: -122.084,
    address: 'Googleplex',
  );

  static Uri getMapApiUri(double lat, double lng) {
    return Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$_googleMapsApiKey',
    );
  }

  static String getLocationImage(PlaceLocation placeLocation) {
    final lat = placeLocation.latitude;
    final lng = placeLocation.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C$lat,$lng&key=$_googleMapsApiKey';
  }
}
