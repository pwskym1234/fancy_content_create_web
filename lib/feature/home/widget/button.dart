import 'package:fancy_content_creation_web/%08widgets/custom_buttons.dart';
import 'package:fancy_content_creation_web/feature/home/logic/controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
// import 'dart:html' as html;

class PickThumbnailButton extends ConsumerWidget {
  const PickThumbnailButton({super.key});

  Future<void> pickImage(WidgetRef ref) async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final html.File file = files.first;
        ref.watch(thumbnailProvider.notifier).setThumbnail(file);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ref.watch(thumbnailProvider);
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          CustomButton(
            color: const Color.fromARGB(255, 255, 164, 28),
            text: 'Thumbnail',
            onPressed: () => pickImage(ref),
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

class PickDescriptionButton extends ConsumerWidget {
  const PickDescriptionButton({
    super.key,
  });

  Future<void> pickImage(WidgetRef ref) async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final html.File file = files.first;
        ref.watch(descriptionProvider.notifier).setDescription(file);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ref.watch(descriptionProvider);
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          CustomButton(
            color: const Color.fromARGB(255, 255, 164, 28),
            text: 'Description',
            onPressed: () => pickImage(ref),
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

class PickPreviewButton extends ConsumerWidget {
  final html.File? file;
  const PickPreviewButton({super.key, required this.file});
  Future<void> pickImage(WidgetRef ref) async {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final html.File file = files.first;
        ref.watch(previewProvider.notifier).addPreview(file);
      }
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          CustomButton(
            color: const Color.fromARGB(255, 255, 164, 28),
            text: 'Preview',
            onPressed: () => pickImage(ref),
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
  final VoidCallback onPressed;
  const UpdateContentButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      color: const Color.fromARGB(255, 15, 247, 255),
      text: 'Update Content',
      onPressed: onPressed,
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

class SelectAllButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SelectAllButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      color: Color.fromARGB(255, 255, 255, 255),
      text: 'Select All',
      onPressed: onPressed,
      height: 50,
      width: 140,
      strokeGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color.fromARGB(255, 255, 255, 255),
          const Color.fromARGB(255, 0, 0, 0),
        ],
      ),
    );
  }
}

class DiselectAllButton extends StatelessWidget {
  final VoidCallback onPressed;
  const DiselectAllButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      color: Color.fromARGB(255, 255, 255, 255),
      text: 'Diselect All',
      onPressed: onPressed,
      height: 50,
      width: 140,
      strokeGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color.fromARGB(255, 255, 255, 255),
          const Color.fromARGB(255, 0, 0, 0),
        ],
      ),
    );
  }
}
