import "dart:io";
import 'package:flutter/material.dart';

import "package:image_picker/image_picker.dart";
import "package:image_cropper/image_cropper.dart";

class ImageInput extends StatefulWidget {
  ImageInput({super.key, required this.onPickImage, this.pickedImage});

  final void Function(File image) onPickImage;
  File? pickedImage;

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  void _takePicture({bool camera = true}) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 600);
    if (pickedImage == null) {
      return;
    }

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Theme.of(context).colorScheme.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedFile == null) return;

    setState(() {
      _selectedImage = File(croppedFile.path);
    });
    widget.onPickImage(_selectedImage!);
  }

  @override
  void initState() {
    if (widget.pickedImage != null) {
      setState(() {
        _selectedImage = widget.pickedImage;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          icon: const Icon(
            Icons.upload,
            color: Colors.black,
          ),
          label: const Text(
            'Upload Picture',
            style: TextStyle(color: Color.fromARGB(169, 0, 0, 0)),
          ),
          onPressed: () => _takePicture(camera: false),
        ),
        TextButton.icon(
          icon: const Icon(
            Icons.camera,
            color: Colors.black,
          ),
          label: const Text(
            'Take Picture',
            style: TextStyle(color: Color.fromARGB(169, 0, 0, 0)),
          ),
          onPressed: () => _takePicture(),
        )
      ],
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
        ),
      );
    }
    return Container(
      alignment: Alignment.center,
      child: content,
    );
  }
}
