import 'dart:io';

import 'package:uuid/uuid.dart';

import 'place_location.dart';

const uuid = Uuid();

class Place {
  Place({
    String? id,
    required this.title,
    required this.image,
    required this.location,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}
