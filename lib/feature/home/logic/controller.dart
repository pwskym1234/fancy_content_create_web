import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_html/html.dart' as html;

final contentTitleControllerProvider =
    Provider((ref) => TextEditingController());
final qaListControllerProvider = StateNotifierProvider<
    QAListControllerNotifierNotifier, TextEditingController>(
  (ref) => QAListControllerNotifierNotifier(),
);
final introControllerProvider = Provider((ref) => TextEditingController());
final contentIDControllerProvider = Provider((ref) => TextEditingController());
final statusProvider = StateProvider<String>((ref) => 'INACTIVE');
final categoryProvider = StateProvider<String>((ref) => 'LOVE');
final fetchedAnswerQuestionMapProvider = StateNotifierProvider<
    FetchedAnswerQuestionMapNotifier, List<Map<dynamic, dynamic>>>(
  (ref) => FetchedAnswerQuestionMapNotifier(),
);
final newContentIdFromResponseProvider =
    StateNotifierProvider<ContentIdNotifier, int>((ref) => ContentIdNotifier());
final previewProvider =
    StateNotifierProvider<PreviewNotifier, List<html.File>>((ref) {
  return PreviewNotifier();
});
final selectedQuestionIdsProvider =
    StateNotifierProvider<SelectedQuestionIdsNotifier, List<int>>((ref) {
  return SelectedQuestionIdsNotifier();
});
final groupedQADataProvider = StateNotifierProvider<GroupedQADataNotifier,
    List<List<Map<dynamic, dynamic>>>>(
  (ref) => GroupedQADataNotifier(),
);
final currentGroupProvider =
    StateNotifierProvider<CurrentGroupNotifier, List<Map<dynamic, dynamic>>>(
  (ref) => CurrentGroupNotifier(),
);

class CurrentGroupNotifier extends StateNotifier<List<Map<dynamic, dynamic>>> {
  CurrentGroupNotifier() : super([]);

  void addQAData(Map<dynamic, dynamic> qa) {
    state = [...state, qa];
  }

  void clearQAData() {
    // state.clear();
    state = [];
    print('State cleared: $state');
  }
}

class GroupedQADataNotifier
    extends StateNotifier<List<List<Map<dynamic, dynamic>>>> {
  GroupedQADataNotifier() : super([]);

  void addGroupedQAData(List<Map<dynamic, dynamic>> group) {
    state = [...state, group];
  }
}

class QAListControllerNotifierNotifier
    extends StateNotifier<TextEditingController> {
  QAListControllerNotifierNotifier() : super(TextEditingController());

  void clear() {
    state.clear();
  }
}

class ContentIdNotifier extends StateNotifier<int> {
  ContentIdNotifier() : super(0);

  void updateContentId(int newId) {
    state = newId;
  }
}

class FetchedAnswerQuestionMapNotifier
    extends StateNotifier<List<Map<dynamic, dynamic>>> {
  FetchedAnswerQuestionMapNotifier() : super([]);

  void updateFetchedAnswerQuestionMap(List<Map<dynamic, dynamic>> newMap) {
    state = newMap;
  }
}

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

class SelectedQuestionIdsNotifier extends StateNotifier<List<int>> {
  SelectedQuestionIdsNotifier() : super([]);

  void updateQuestionId(List<int> newList) {
    state = newList;
  }

  void addQuestionId(int id) {
    state = [...state, id];
  }

  void removeQuestionId(int id) {
    state = state.where((selectedQuestion) => selectedQuestion != id).toList();
  }

  void clearQuestionId() {
    state = [];
    // print('ID cleared: $state');
  }

  void selectAllQuestions(List<List<Map<dynamic, dynamic>>> groupedQAData) {
    state = groupedQAData
        .where((group) => group.isNotEmpty)
        .map<int>((group) => group.first['question_id'] as int)
        .toList();
    // print('ID selected: $state');
  }
}
