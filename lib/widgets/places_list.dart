import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app/models/place.dart';
import 'package:flutter_favorite_places_app/providers/places_provider.dart';
import 'package:flutter_favorite_places_app/screens/place_details_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerWidget {
  const PlacesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final places = ref.watch(placesProvider);
    final notifiers = ref.watch(placesProvider.notifier);

    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarHeight = AppBar().preferredSize.height;
    final availableHeight = screenHeight - appBarHeight;

    void openPlaceDetails(Place place) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => PlaceDetailsScreen(place: place)),
      );
    }

    void onRemove(Place place, int index) {
      notifiers.removePlace(place);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
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
    }

    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 500),
      crossFadeState:
          places.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: SizedBox(
        height: availableHeight,
        child: Center(
          child: Text(
            'No places added yet!',
            style: theme.textTheme.titleMedium!.copyWith(
              fontSize: 24,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
      secondChild: SizedBox(
        height: availableHeight,
        child: ListView.builder(
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
              minLeadingWidth: 24,
              horizontalTitleGap: 24,
              minVerticalPadding: 0,
              minTileHeight: 0,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              title: Text(
                places[index].title,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontSize: 20,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              onTap: () => openPlaceDetails(places[index]),
            ),
          ),
        ),
      ),
    );
  }
}
