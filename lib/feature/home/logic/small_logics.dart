// status_manager.dart
import 'package:fancy_content_creation_web/feature/home/logic/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void updateStatusLogic(BuildContext context, WidgetRef ref, String status) {
  ref.read(statusProvider.notifier).state = status;
}

void updateCategoryLogic(BuildContext context, WidgetRef ref, String category) {
  ref.read(categoryProvider.notifier).state = category;
}
