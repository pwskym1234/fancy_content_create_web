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
  List<Map<String, dynamic>> questions = [];
  List<Map<String, dynamic>> answers = [];
  List<String> newFormattedQAList = splitText(qaText);
  newFormattedQAList = newFormattedQAList.map((qa) {
    return qa.replaceAll(RegExp(r'^\(\d+\)'), '').trim();
  }).toList();

  try {
    Map<int, int> questionIds = {};
    Map<String, int> questionTextToIdMap = {};

    for (String qa in newFormattedQAList) {
      if (qa.startsWith('Q:')) {
        String questionText = qa.substring(2).trim();
        debugPrint('Creating question: $questionText');
        Response questionResponse =
            await apiService.createQuestion(contentID!, questionText);
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
            contentID!, answerText, previousQuestionId,
            nextQuestionId: nextQuestionId);
        debugPrint('Answer created successfully');
      }
    }

    // if (context.mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Updated successfully')),
    //   );
    // }
    // debugPrint('Updated successfully');
  } catch (e) {
    debugPrint('Error occurred: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting Q&A: $e')),
      );
    }
  }

  int questionOffset = 0;
  bool questionHasMore = true;
  while (questionHasMore) {
    try {
      debugPrint('$contentIDController');
      Response questionResponse = await apiService.listQuestionForAdmin(
          contentID ?? 0, questionOffset, 100);

      List<Map<String, dynamic>> fetchedQuestions =
          List<Map<String, dynamic>>.from(questionResponse.data);
      questions.addAll(fetchedQuestions);

      debugPrint("Questions fetched successfully: $fetchedQuestions");

      if (fetchedQuestions.length < 100) {
        questionHasMore = false;
      } else {
        questionOffset += 100;
      }
    } catch (e) {
      debugPrint('Error occurred while fetching questions: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching questions: $e')),
        );
      }
      return;
    }
  }

  // Fetch all answers with pagination
  int answerOffset = 0;
  bool answerHasMore = true;
  while (answerHasMore) {
    try {
      Response answerResponse = await apiService.listAnswerForAdmin(
          contentID ?? 0, answerOffset, 100);

      // Directly use the response data as a List
      List<Map<String, dynamic>> fetchedAnswers =
          List<Map<String, dynamic>>.from(answerResponse.data);
      answers.addAll(fetchedAnswers);

      debugPrint("Answers fetched successfully: $fetchedAnswers");

      if (fetchedAnswers.length < 100) {
        answerHasMore = false;
      } else {
        answerOffset += 100;
      }
    } catch (e) {
      debugPrint('Error occurred while fetching answers: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching answers: $e')),
        );
      }
      return;
    }
  }

  try {
    Map<int, Map<dynamic, dynamic>> answerQuestionMap = {};

    for (var answer in answers) {
      answerQuestionMap[answer['id']] = {
        'answer': answer['text'],
        'question_text': '',
        'question_id': '',
        'next_question_text': '',
        'next_question_id': ''
      };

      debugPrint(
          "Processing answer ID: ${answer['id']}, Text: ${answer['text']}");

      for (var question in questions) {
        int questionId = answer['question_id'];
        int? nextQuestionId = answer['next_question_id'];

        if (question['id'] == questionId) {
          answerQuestionMap[answer['id']]?['question_text'] = question['text'];
          answerQuestionMap[answer['id']]?['question_id'] = question['id'];
          debugPrint(
              "    Matched question ID: $questionId, Text: ${question['text']}");
        }
        if (nextQuestionId != null && question['id'] == nextQuestionId) {
          answerQuestionMap[answer['id']]?['next_question_text'] =
              question['text'];
          answerQuestionMap[answer['id']]?['next_question_id'] = question['id'];
          debugPrint(
              "    Matched next question ID: $nextQuestionId, Text: ${question['text']}");
        }
      }
    }

    debugPrint("Final answerQuestionMap: $answerQuestionMap");
    ref
        .read(fetchedAnswerQuestionMapProvider.notifier)
        .updateFetchedAnswerQuestionMap(answerQuestionMap.values.toList());
    debugPrint(
        "Final answerQuestionMap: ${ref.read(fetchedAnswerQuestionMapProvider)}");
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fetched successfully')),
      );
    }
    debugPrint("QA Data set to state");
  } catch (e) {
    debugPrint('Error occurred while combining QA data: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching QA data: $e')),
      );
    }
  }

  try {
    final fetchedData = ref.watch(fetchedAnswerQuestionMapProvider);

    for (var qa in fetchedData) {
      ref.watch(currentGroupProvider.notifier).addQAData(qa);
      if (qa['next_question_id'] == '' && qa['next_question_text'] == '') {
        ref
            .watch(groupedQADataProvider.notifier)
            .addGroupedQAData(ref.watch(currentGroupProvider));
        ref.watch(currentGroupProvider.notifier).clearQAData();
      }
    }

    if (ref.watch(currentGroupProvider).isNotEmpty) {
      ref
          .watch(groupedQADataProvider.notifier)
          .addGroupedQAData(ref.watch(currentGroupProvider));
    }

    debugPrint("Received qaData: $fetchedData");

    debugPrint(
        "Number of created groups: ${ref.watch(groupedQADataProvider).length}");
  } catch (e) {}

  try {
    debugPrint('Updating content with contentID: $contentID');
    List<int> getFirstQuestionIds(WidgetRef ref) {
      List<int> firstQuestionIds = [];
      for (var group in ref.watch(groupedQADataProvider)) {
        var qa = group.first;
        firstQuestionIds.add(qa['question_id']);
      }

      return firstQuestionIds;
    }

    List<int> firstQuestionList = getFirstQuestionIds(ref);
    await apiService.updateContent(
      contentID!,
      firstQuestionList:
          firstQuestionList.isNotEmpty ? firstQuestionList : null,
    );
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
        SnackBar(content: Text('Error updating: $e')),
      );
    }
  }
}
