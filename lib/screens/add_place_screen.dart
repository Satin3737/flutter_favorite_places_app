import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app/models/place_location.dart';
import 'package:flutter_favorite_places_app/providers/places_provider.dart';
import 'package:flutter_favorite_places_app/widgets/image_input.dart';
import 'package:flutter_favorite_places_app/widgets/location_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  File? _image;
  PlaceLocation? _location;

  void _saveForm() {
    if (_formKey.currentState!.validate() &&
        _image != null &&
        _location != null) {
      _formKey.currentState!.save();

      ref.read(placesProvider.notifier).addPlace(
            title: _title,
            image: _image!,
            location: _location!,
          );

      Navigator.of(context).pop();
    }
  }

  void _selectImage(File image) => _image = image;
  void _selectLocation(PlaceLocation location) => _location = location;

  @override
  Widget build(BuildContext context) {
    final cScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Add Place'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 24,
            children: [
              TextFormField(
                style: TextStyle(color: cScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Title',
                  prefixIcon: const Icon(Icons.label),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: cScheme.onSurface),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  if (value.trim().length < 2) {
                    return 'Title must be at least 2 characters long';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              ImageInput(onSelectImage: _selectImage),
              LocationInput(onSelectLocation: _selectLocation),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Add Place'),
                onPressed: _saveForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
