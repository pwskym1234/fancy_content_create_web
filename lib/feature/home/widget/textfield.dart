// lib/widgets/custom_textfields.dart
import 'package:fancy_content_creation_web/feature/home/logic/controller.dart';
import 'package:fancy_content_creation_web/widgets/custom_textfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define specific text fields for reuse
class ContentTitleTextField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTextField(
      controller: ref.watch(contentTitleControllerProvider),
      hintText: 'Content Title',
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      textStyle: const TextStyle(color: Colors.white),
    );
  }
}

class ContentIDTextField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTextField(
      controller: ref.watch(contentIDControllerProvider),
      hintText: 'Content ID',
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      textStyle: const TextStyle(color: Colors.white),
    );
  }
}

class ContentIntroTextField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTextField(
      controller: ref.watch(introControllerProvider),
      hintText: 'Content Intro',
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      textStyle: const TextStyle(color: Colors.white),
    );
  }
}

class QAListTextField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTextField(
      controller: ref.watch(qaListControllerProvider),
      hintText: 'Q&A list',
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
      textStyle: const TextStyle(color: Colors.white),
      maxLines: 7,
    );
  }
}
