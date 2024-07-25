import 'package:dio/dio.dart';
import 'package:fancy_content_creation_web/data/api_service.dart';
import 'package:fancy_content_creation_web/feature/home/logic/controller.dart';
import 'package:fancy_content_creation_web/feature/home/logic/fetch_logic.dart';
import 'package:fancy_content_creation_web/feature/home/logic/small_logics.dart';
import 'package:fancy_content_creation_web/feature/home/logic/update_content_logic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';

Future<void> createContentLogic({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final contentTitleController = ref.read(contentTitleControllerProvider);
  final introController = ref.read(introControllerProvider);
  final categoryController = ref.read(categoryProvider);
  final qaController = ref.read(qaListControllerProvider);
  final apiService = ref.read(apiServiceProvider);
  final thumbnail = ref.read(thumbnailProvider);
  final description = ref.read(descriptionProvider);
  final averageRating = ref.read(averageRatingProvider);
  final wordCount = ref.read(wordCountProvider);
  String contentTitle = contentTitleController.text;
  String intro = introController.text;
  String contentCategory = categoryController;
  String qaText = qaController.text;

  List<String> newFormattedQAList = splitText(qaText);
  newFormattedQAList = newFormattedQAList.map((qa) {
    return qa.replaceAll(RegExp(r'^\(\d+\)'), '').trim();
  }).toList();

  try {
    debugPrint(
        'Creating content with contentTitle: $contentTitle and category: $contentCategory');
    Response contentResponse = await apiService.createContent(
        contentTitle, contentCategory,
        thumbnail: thumbnail,
        description: description,
        introText: intro,
        averageRating: averageRating,
        wordCount: wordCount);
    int newContentIdFromResponse = contentResponse.data['id'];
    ref
        .read(newContentIdFromResponseProvider.notifier)
        .updateContentId(newContentIdFromResponse);
    debugPrint('Content created with ID: $newContentIdFromResponse');
    debugPrint(
        'Content created with ID: ${ref.watch(newContentIdFromResponseProvider)}');

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

    for (int i = 0; i < newFormattedQAList.length; i++) {
      String qa = newFormattedQAList[i];
      if (qa.startsWith('A:')) {
        String answerText = qa.substring(2).trim();
        bool hadQuote = false;
        while (answerText.endsWith('"')) {
          answerText = answerText.substring(0, answerText.length - 1).trim();
          hadQuote = true;
        }

        int answerIndex = i;
        debugPrint('answerindex: $answerIndex');
        String previousQuestionText =
            findPreviousQuestionText(answerIndex, newFormattedQAList);
        debugPrint('Creating previous question: $previousQuestionText');
        int previousQuestionId = questionTextToIdMap[previousQuestionText] ?? 0;

        String nextQuestionText = '';
        int? nextQuestionId;

        if (!hadQuote) {
          nextQuestionText =
              findNextQuestionText(answerIndex, newFormattedQAList);
          nextQuestionId = questionTextToIdMap[nextQuestionText];
        }

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
        const SnackBar(content: Text('Created successfully')),
      );
    }
    debugPrint('Created successfully');

    await fetchQADataLogic(
      context: context,
      ref: ref,
    );
    ref
        .watch(selectedQuestionIdsProvider.notifier)
        .selectAllQuestions(ref.watch(groupedQADataProvider));
    await updateContentLogic(
      context: context,
      ref: ref,
    );
  } catch (e) {
    debugPrint('Error occurred: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting Q&A: $e')),
      );
    }
  }
}
