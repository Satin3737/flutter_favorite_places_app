import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    this.currentImage,
    required this.onSelectImage,
  });

  final File? currentImage;
  final void Function(File image) onSelectImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _chosenImage;

  @override
  void initState() {
    super.initState();
    _chosenImage = widget.currentImage;
  }

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (image == null) return;
    setState(() => _chosenImage = File(image.path));
    widget.onSelectImage(_chosenImage!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        Icon(Icons.camera, color: theme.colorScheme.onSurface),
        Text(
          'Take a picture',
          style: theme.textTheme.titleMedium!.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );

    if (_chosenImage != null) {
      content = Image.file(
        _chosenImage!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return GestureDetector(
      onTap: _takePicture,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          alignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.onSurface,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: content,
        ),
      ),
    );
  }
}
