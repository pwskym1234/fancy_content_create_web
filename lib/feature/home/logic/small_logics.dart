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
