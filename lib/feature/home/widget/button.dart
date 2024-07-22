import 'package:fancy_content_creation_web/%08widgets/custom_buttons.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';

class PickThumbnailButton extends StatelessWidget {
  final html.File? file;
  final void Function(html.File) onPicked;
  const PickThumbnailButton(
      {super.key, required this.file, required this.onPicked});

  Future<void> pickImage() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final html.File file = files.first;
        onPicked(file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          CustomButton(
            color: const Color.fromARGB(255, 255, 164, 28),
            text: 'Thumbnail',
            onPressed: pickImage,
            height: 60,
            width: 140,
            strokeGradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 215, 215, 215),
                Color.fromARGB(255, 255, 164, 28),
                Color.fromARGB(255, 255, 164, 28),
                Color.fromARGB(255, 176, 48, 2),
                Color.fromARGB(255, 254, 87, 9),
              ],
            ),
          ),
          if (file != null)
            Image.network(
              html.Url.createObjectUrlFromBlob(file!),
              height: 100,
              width: 100,
            ),
        ],
      ),
    );
  }
}

class PickDescriptionButton extends StatelessWidget {
  final html.File? file;
  final void Function(html.File) onPicked;
  const PickDescriptionButton(
      {super.key, required this.file, required this.onPicked});

  Future<void> pickImage() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final html.File file = files.first;
        onPicked(file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          CustomButton(
            color: const Color.fromARGB(255, 255, 164, 28),
            text: 'Description',
            onPressed: pickImage,
            height: 60,
            width: 140,
            strokeGradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 215, 215, 215),
                Color.fromARGB(255, 255, 164, 28),
                Color.fromARGB(255, 255, 164, 28),
                Color.fromARGB(255, 176, 48, 2),
                Color.fromARGB(255, 254, 87, 9),
              ],
            ),
          ),
          if (file != null)
            Image.network(
              html.Url.createObjectUrlFromBlob(file!),
              height: 100,
              width: 100,
            ),
        ],
      ),
    );
  }
}

class PickPreviewButton extends StatelessWidget {
  final html.File? file;
  final void Function(html.File) onPicked;
  const PickPreviewButton(
      {super.key, required this.file, required this.onPicked});
  Future<void> pickImage() async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final html.File file = files.first;
        onPicked(file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          CustomButton(
            color: const Color.fromARGB(255, 255, 164, 28),
            text: 'Preview',
            onPressed: pickImage,
            height: 60,
            width: 140,
            strokeGradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 215, 215, 215),
                Color.fromARGB(255, 255, 164, 28),
                Color.fromARGB(255, 255, 164, 28),
                Color.fromARGB(255, 176, 48, 2),
                Color.fromARGB(255, 254, 87, 9),
              ],
            ),
          ),
          if (file != null)
            Image.network(
              html.Url.createObjectUrlFromBlob(file!),
              height: 100,
              width: 100,
            ),
        ],
      ),
    );
  }
}

class CreateContentButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CreateContentButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      color: const Color.fromARGB(255, 255, 17, 251),
      text: 'Create Content',
      onPressed: onPressed,
      height: 80,
      width: 280,
      strokeGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromARGB(255, 215, 215, 215),
          Color.fromARGB(255, 255, 17, 251),
          Color.fromARGB(255, 255, 17, 251),
          Color.fromARGB(255, 255, 17, 251),
          Color.fromARGB(255, 255, 17, 251),
          Color.fromARGB(255, 255, 104, 17),
          Color.fromARGB(255, 255, 17, 128),
          Color.fromARGB(255, 234, 58, 0),
        ],
      ),
    );
  }
}

class UpdateContentButton extends StatelessWidget {
  const UpdateContentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      color: const Color.fromARGB(255, 15, 247, 255),
      text: 'Update Content',
      onPressed: () {},
      height: 80,
      width: 280,
      strokeGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromARGB(255, 215, 215, 215),
          Color.fromARGB(255, 15, 247, 255),
          Color.fromARGB(255, 15, 247, 255),
          Color.fromARGB(255, 15, 247, 255),
          Color.fromARGB(255, 15, 247, 255),
          Color.fromARGB(255, 70, 4, 163),
          Color.fromARGB(255, 21, 1, 48),
        ],
      ),
    );
  }
}

class FetchContentButton extends StatelessWidget {
  final VoidCallback onPressed;
  const FetchContentButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      color: const Color.fromARGB(255, 255, 15, 239),
      text: 'Fetch Content',
      onPressed: onPressed,
      height: 60,
      width: 180,
      strokeGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.fromARGB(255, 215, 215, 215),
          Color.fromARGB(255, 255, 15, 239),
          Color.fromARGB(255, 255, 15, 239),
          Color.fromARGB(255, 255, 131, 15),
          Color.fromARGB(255, 255, 231, 15),
          Color.fromARGB(255, 105, 12, 255),
        ],
      ),
    );
  }
}
