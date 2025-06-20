import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerButtons extends StatelessWidget {
  final void Function(ImageSource source) onPick;

  const ImagePickerButtons({super.key, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.camera_alt),
          label: const Text("Camera"),
          onPressed: () => onPick(ImageSource.camera),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.photo),
          label: const Text("Gallery"),
          onPressed: () => onPick(ImageSource.gallery),
        ),
      ],
    );
  }
}
