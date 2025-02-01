import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app/helper/db_helper.dart';
import 'package:flutter_favorite_places_app/models/place.dart';
import 'package:flutter_favorite_places_app/providers/places_provider.dart';
import 'package:flutter_favorite_places_app/screens/place_details_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerWidget {
  const PlacesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placesProvider);
    final theme = Theme.of(context);

    void openPlaceDetails(Place place) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => PlaceDetailsScreen(place: place)),
      );
    }

    void onRemove(Place place, int index) {
      final notifiers = ref.read(placesProvider.notifier);
      notifiers.removePlace(place);

      ScaffoldMessenger.of(context).clearSnackBars();
      final snackBar = ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${place.title} removed'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              notifiers.revertPlaceRemoval(place, index);
            },
          ),
        ),
      );

      snackBar.closed.then((reason) {
        if (reason != SnackBarClosedReason.action) {
          DbHelper.delete(place.id);
        }
      });
    }

    if (places.isEmpty) {
      return Center(
        child: Text(
          'No places added yet!',
          style: theme.textTheme.titleMedium!.copyWith(
            fontSize: 24,
            color: theme.colorScheme.onSurface,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: places.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(places[index]),
        onDismissed: (_) => onRemove(places[index], index),
        background: Container(
          color: Colors.redAccent,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          child: Icon(
            Icons.delete,
            size: 32,
            color: theme.colorScheme.onSurface,
          ),
        ),
        child: ListTile(
          horizontalTitleGap: 16,
          minVerticalPadding: 0,
          minTileHeight: 0,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          title: Hero(
            tag: '${places[index].id}-title',
            child: Text(
              places[index].title,
              style: theme.textTheme.titleMedium!.copyWith(
                fontSize: 20,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          subtitle: Text(
            places[index].location.address,
            style: theme.textTheme.bodySmall!.copyWith(
              fontSize: 12,
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
          leading: Hero(
            tag: places[index].id,
            child: CircleAvatar(
              radius: 24,
              backgroundImage: FileImage(places[index].image),
            ),
          ),
          onTap: () => openPlaceDetails(places[index]),
        ),
      ),
    );
  }
}
