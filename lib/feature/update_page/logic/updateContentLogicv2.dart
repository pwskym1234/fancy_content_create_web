import 'package:dio/dio.dart';
import 'package:fancy_content_creation_web/data/api_service.dart';
import 'package:fancy_content_creation_web/feature/home/logic/controller.dart';
import 'package:fancy_content_creation_web/feature/home/logic/create_content_logic.dart';
import 'package:fancy_content_creation_web/feature/home/logic/small_logics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_html/html.dart' as html;

import 'package:flutter/material.dart';

Future<void> updateContentLogicv2({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final qaController = ref.read(qaListControllerProvider);
  final contentIDController = ref.watch(contentIDControllerProvider);
  final apiService = ref.read(apiServiceProvider);
  final firstQuestionList = ref.read(selectedQuestionIdsProvider);
  String qaText = qaController.text;
  int? contentID = int.tryParse(contentIDController.text);

  List<String> newFormattedQAList = splitText(qaText);
  newFormattedQAList = newFormattedQAList.map((qa) {
    return qa.replaceAll(RegExp(r'^\(\d+\)'), '').trim();
  }).toList();

  try {
    debugPrint('Updating content with contentID: $contentID');

    Response contentResponse = await apiService.updateContent(
      contentID!,
      firstQuestionList:
          firstQuestionList.isNotEmpty ? firstQuestionList : null,
    );
    int newContentIdFromResponse = contentResponse.data['id'];
    ref
        .read(newContentIdFromResponseProvider.notifier)
        .updateContentId(newContentIdFromResponse);
    debugPrint('Content ID: $newContentIdFromResponse');

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
        if (answerText.contains('"') || answerText.contains('" "')) {
          nextQuestionId = null;
          answerText = answerText.replaceAll('"', '');
        }

        debugPrint('Creating answer: $answerText');
        debugPrint('Previous question ID: $previousQuestionId');
        debugPrint('Next question ID: $nextQuestionId');
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
