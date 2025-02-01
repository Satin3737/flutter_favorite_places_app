import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app/helper/db_helper.dart';
import 'package:flutter_favorite_places_app/providers/places_provider.dart';
import 'package:flutter_favorite_places_app/screens/add_place_screen.dart';
import 'package:flutter_favorite_places_app/widgets/places_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = _initPlacesDb();
  }

  Future<void> _initPlacesDb() async {
    await DbHelper.init();
    return ref.read(placesProvider.notifier).fetchPlaces();
  }

  void _addPlace() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => AddPlaceScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addPlace,
          ),
        ],
      ),
      body: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.error != null) {
              return Center(child: Text('An error occurred!'));
            }

            return const PlacesList();
          }),
    );
  }
}
