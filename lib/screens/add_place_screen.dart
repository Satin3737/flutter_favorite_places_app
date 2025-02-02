import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_favorite_places_app/helper/path_helper.dart';
import 'package:flutter_favorite_places_app/models/place.dart';
import 'package:flutter_favorite_places_app/models/place_location.dart';
import 'package:flutter_favorite_places_app/providers/places_provider.dart';
import 'package:flutter_favorite_places_app/widgets/image_input.dart';
import 'package:flutter_favorite_places_app/widgets/location_input.dart';
import 'package:flutter_favorite_places_app/widgets/validation_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key, this.editPlace});

  final Place? editPlace;

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _image;
  PlaceLocation? _location;

  @override
  void initState() {
    super.initState();

    if (widget.editPlace != null) {
      _titleController.text = widget.editPlace!.title;
      _image = widget.editPlace!.image;
      _location = widget.editPlace!.location;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => ValidationDialog(message: message),
    );
  }

  bool _validateForm() {
    final title = _titleController.text.trim();

    if (title.isEmpty && _image == null && _location == null) {
      _showErrorDialog('All fields are required');
      return false;
    }

    if (title.isEmpty) {
      _showErrorDialog('Title is required');
      return false;
    }
    if (title.length < 2) {
      _showErrorDialog('Title must be at least 2 characters long');
      return false;
    }
    if (_image == null) {
      _showErrorDialog('Image is required');
      return false;
    }
    if (_location == null) {
      _showErrorDialog('Location is required');
      return false;
    }

    return true;
  }

  void _saveForm() async {
    final title = _titleController.text.trim();

    if (_validateForm()) {
      final notifier = ref.read(placesProvider.notifier);

      if (widget.editPlace == null) {
        notifier.addPlace(
          title: title,
          image: _image!,
          location: _location!,
        );
      } else {
        notifier.updatePlace(
          id: widget.editPlace!.id,
          title: title,
          image: widget.editPlace!.image != _image
              ? await PathHelper.copyImage(_image!)
              : _image!,
          location: _location!,
        );
      }

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _selectImage(File image) => _image = image;
  void _selectLocation(PlaceLocation location) => _location = location;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

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
        child: Column(
          spacing: 24,
          children: [
            TextField(
              controller: _titleController,
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
            ),
            ImageInput(
              currentImage: _image,
              onSelectImage: _selectImage,
            ),
            LocationInput(
              currentLocation: _location,
              onSelectLocation: _selectLocation,
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.add),
              label: Text(
                widget.editPlace == null ? 'Add Place' : 'Update Place',
              ),
              onPressed: _saveForm,
            ),
          ],
        ),
      ),
    );
  }
}
