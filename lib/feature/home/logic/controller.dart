import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_html/html.dart' as html;

final contentTitleControllerProvider =
    Provider((ref) => TextEditingController());
final qaListControllerProvider = Provider((ref) => TextEditingController());
final introControllerProvider = Provider((ref) => TextEditingController());
final contentIDControllerProvider = Provider((ref) => TextEditingController());
final statusControllerProvider = Provider((ref) => TextEditingController());
final categoryControllerProvider = Provider((ref) => TextEditingController());
final statusProvider = StateProvider<String>((ref) => 'INACTIVE');
final categoryProvider = StateProvider<String>((ref) => 'LOVE');
final newFormattedQAListProvider = StateProvider<List<String>>((ref) => []);
final newContentIdFromResponseProvider = StateProvider<int>((ref) => 0);

class ThumbnailNotifier extends StateNotifier<html.File?> {
  ThumbnailNotifier() : super(null);

  void setThumbnail(html.File? file) {
    state = file;
  }
}

final thumbnailProvider =
    StateNotifierProvider<ThumbnailNotifier, html.File?>((ref) {
  return ThumbnailNotifier();
});

class DescriptionNotifier extends StateNotifier<html.File?> {
  DescriptionNotifier() : super(null);

  void setDescription(html.File? file) {
    state = file;
  }
}

final descriptionProvider =
    StateNotifierProvider<DescriptionNotifier, html.File?>((ref) {
  return DescriptionNotifier();
});

class PreviewNotifier extends StateNotifier<List<html.File>> {
  PreviewNotifier() : super([]);

  void addPreview(html.File file) {
    state = [...state, file];
  }

  void removePreview(html.File file) {
    state = state.where((preview) => preview != file).toList();
  }

  void clearPreviews() {
    state = [];
  }
}

final previewProvider =
    StateNotifierProvider<PreviewNotifier, List<html.File>>((ref) {
  return PreviewNotifier();
});
