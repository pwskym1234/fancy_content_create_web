import 'package:dio/dio.dart';
import 'package:fancy_content_creation_web/data/api_service.dart';
import 'package:fancy_content_creation_web/feature/home/logic/controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_html/html.dart' as html;

import 'package:flutter/material.dart';

Future<void> createContentLogic({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final contentTitleController = ref.read(contentTitleControllerProvider);
  final categoryController = ref.read(categoryProvider);
  final qaController = ref.read(qaListControllerProvider);
  final apiService = ref.read(apiServiceProvider);
  final thumbnail = ref.read(thumbnailProvider);
  final description = ref.read(descriptionProvider);
  String contentTitle = contentTitleController.text;
  String contentCategory = categoryController;
  String qaText = qaController.text;

  List<String> newFormattedQAList = splitText(qaText);
  newFormattedQAList = newFormattedQAList.map((qa) {
    return qa.replaceAll(RegExp(r'^\(\d+\)'), '').trim();
  }).toList();

  // ref
  //     .read(newFormattedQAListProvider.notifier)
  //     .updateFormattedQAList(newFormattedQAList);

  try {
    debugPrint(
        'Creating content with contentTitle: $contentTitle and category: $contentCategory');
    Response contentResponse = await apiService.createContent(
      contentTitle,
      contentCategory,
      thumbnail: thumbnail,
      description: description,
    );
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
        const SnackBar(content: Text('Q&A submitted successfully')),
      );
    }
    debugPrint('Q&A submitted successfully');
  } catch (e) {
    debugPrint('Error occurred: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting Q&A: $e')),
      );
    }
  }
}

String findPreviousQuestionText(int answerIndex, List<String> formattedQAList) {
  for (int i = answerIndex; i >= 0; i--) {
    if (formattedQAList[i].startsWith('Q:')) {
      return formattedQAList[i].substring(2).trim();
    }
  }
  return 'No previous question';
}

String findNextQuestionText(int answerIndex, List<String> formattedQAList) {
  for (int i = answerIndex + 1; i < formattedQAList.length; i++) {
    if (formattedQAList[i].startsWith('Q:')) {
      return formattedQAList[i].substring(2).trim();
    }
  }
  return 'No next question';
}

List<String> splitText(String text) {
  debugPrint('Input text: $text');

  List<String> questionsAndAnswers = text.split(RegExp(r'(?=Q:)|(?=A:)'));
  debugPrint('Split into questions and answers: $questionsAndAnswers');

  List<String> qaList = [];

  for (String qa in questionsAndAnswers) {
    qaList.add(qa.trim());
  }

  debugPrint('Formatted QA List: $qaList');
  return qaList;
}
