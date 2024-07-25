import 'package:dio/dio.dart';
import 'package:fancy_content_creation_web/data/api_service.dart';
import 'package:fancy_content_creation_web/feature/home/logic/controller.dart';
import 'package:fancy_content_creation_web/feature/home/logic/create_content_logic.dart';
import 'package:fancy_content_creation_web/feature/home/logic/small_logics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_html/html.dart' as html;

import 'package:flutter/material.dart';

Future<void> updateContentLogic({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final contentTitleController = ref.read(contentTitleControllerProvider);
  final introController = ref.read(introControllerProvider);
  final qaController = ref.read(qaListControllerProvider);
  // final contentIDController = ref.read(newContentIdFromResponseProvider);
  final contentIDController = ref.watch(contentIDControllerProvider);
  final categoryController = ref.read(categoryProvider);
  final statusController = ref.read(statusProvider);
  final apiService = ref.read(apiServiceProvider);
  final thumbnail = ref.read(thumbnailProvider);
  final description = ref.read(descriptionProvider);
  final firstQuestionList = ref.read(selectedQuestionIdsProvider);
  final preview = ref.read(previewProvider);
  final averageRating = ref.read(averageRatingProvider);
  final wordCount = ref.read(wordCountProvider);
  String qaText = qaController.text;
  String introText = introController.text;
  String titleText = contentTitleController.text;
  int? contentID = int.tryParse(contentIDController.text);
  String? status =
      statusController.isNotEmpty == true ? statusController : null;
  String? category =
      categoryController.isNotEmpty == true ? categoryController : null;

  // if (contentID == null) {
  //   if (context.mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Content ID must be a valid integer')),
  //     );
  //   }
  //   return;
  // }

  List<String> newFormattedQAList = splitText(qaText);
  newFormattedQAList = newFormattedQAList.map((qa) {
    return qa.replaceAll(RegExp(r'^\(\d+\)'), '').trim();
  }).toList();

  try {
    debugPrint('Updating content with contentID: $contentID');

    Response contentResponse = await apiService.updateContent(
      contentID!,
      thumbnail: thumbnail,
      description: description,
      status: status,
      category: category,
      previews: preview,
      introText: introText.isNotEmpty ? introText : null,
      title: titleText.isNotEmpty ? titleText : null,
      averageRating: averageRating,
      wordCount: wordCount,
      firstQuestionList:
          firstQuestionList.isNotEmpty ? firstQuestionList : null,
    );
    int newContentIdFromResponse = contentResponse.data['id'];
    ref
        .read(newContentIdFromResponseProvider.notifier)
        .updateContentId(newContentIdFromResponse);
    debugPrint('Content created with ID: $newContentIdFromResponse');

    Map<int, int> questionIds = {};
    Map<String, int> questionTextToIdMap = {};

    for (String qa in newFormattedQAList) {
      if (qa.startsWith('Q:')) {
        String questionText = qa.substring(2).trim();
        debugPrint('Creating question: $questionText');
        Response questionResponse = await apiService.createQuestion(
            newContentIdFromResponse, questionText);
        int questionId = questionResponse.data['id'];
        String questionTextFromResponse = questionResponse.data['text'].trim();
        questionTextToIdMap[questionTextFromResponse] = questionId;
        debugPrint('Question created with ID: $questionId');
        questionIds[newFormattedQAList.indexOf(qa)] = questionId;
      }
    }

    for (String qa in newFormattedQAList) {
      if (qa.startsWith('A:')) {
        String answerText = qa.substring(2).trim();
        int answerIndex = newFormattedQAList.indexOf(qa);
        String previousQuestionText =
            findPreviousQuestionText(answerIndex, newFormattedQAList);
        String nextQuestionText =
            findNextQuestionText(answerIndex, newFormattedQAList);
        int previousQuestionId = questionTextToIdMap[previousQuestionText] ?? 0;
        int? nextQuestionId = questionTextToIdMap[nextQuestionText];

        debugPrint('Creating answer: $answerText');
        debugPrint('Previous question ID: $previousQuestionId');
        debugPrint('Next question ID: $nextQuestionId');
        debugPrint('content ID: $newContentIdFromResponse');
        await apiService.createAnswer(
            newContentIdFromResponse, answerText, previousQuestionId,
            nextQuestionId: nextQuestionId);
        debugPrint('Answer created successfully');
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Updated successfully')),
      );
    }
    debugPrint('Updated successfully');
  } catch (e) {
    debugPrint('Error occurred: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting Q&A: $e')),
      );
    }
  }
}
