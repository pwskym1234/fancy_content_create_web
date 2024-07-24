import 'package:dio/dio.dart';
import 'package:fancy_content_creation_web/data/api_service.dart';
import 'package:fancy_content_creation_web/feature/home/logic/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> fetchQADataLogic({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final apiService = ref.read(apiServiceProvider);
  // final contentIDController = ref.watch(contentIDControllerProvider);
  final contentIDController = ref.watch(newContentIdFromResponseProvider);
  List<Map<String, dynamic>> questions = [];
  List<Map<String, dynamic>> answers = [];

  int questionOffset = 0;
  bool questionHasMore = true;
  while (questionHasMore) {
    try {
      debugPrint('$contentIDController');
      Response questionResponse = await apiService.listQuestionForAdmin(
          contentIDController ?? 0, questionOffset, 100);

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
          contentIDController ?? 0, answerOffset, 100);

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
}
