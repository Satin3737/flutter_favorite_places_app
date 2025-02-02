import 'dart:io';

import 'package:flutter_favorite_places_app/models/place.dart';
import 'package:flutter_favorite_places_app/models/place_location.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DbHelper {
  static late final sql.Database db;

  static Future<void> init() async {
    await openDb();
  }

  static Future<void> openDb() async {
    final dbPath = await sql.getDatabasesPath();

    db = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE places(id TEXT PRIMARY KEY, title TEXT, image TEXT, latitude REAL, longitude REAL, address TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<List<Place>> getPlaces() async {
    final data = await db.query('places');
    return data.map(
      (row) {
        return Place(
          id: row['id'] as String,
          title: row['title'] as String,
          image: File(row['image'] as String),
          location: PlaceLocation(
            latitude: row['latitude'] as double,
            longitude: row['longitude'] as double,
            address: row['address'] as String,
          ),
        );
      },
    ).toList();
  }

  static Future<void> insert(Place place) async {
    db.insert(
      'places',
      {
        'id': place.id,
        'title': place.title,
        'image': place.image.path,
        'latitude': place.location.latitude,
        'longitude': place.location.longitude,
        'address': place.location.address,
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> update(Place place) async {
    db.update(
      'places',
      {
        'title': place.title,
        'image': place.image.path,
        'latitude': place.location.latitude,
        'longitude': place.location.longitude,
        'address': place.location.address,
      },
      where: 'id = ?',
      whereArgs: [place.id],
    );
  }

  static Future<void> delete(String id) async {
    db.delete('places', where: 'id = ?', whereArgs: [id]);
  }
}
