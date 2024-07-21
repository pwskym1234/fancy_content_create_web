import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'token_storage.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://api.sotrue.me/api/v1';

  Future<List<int>> _readFileAsBytes(html.File file) {
    final reader = html.FileReader();
    final completer = Completer<List<int>>();

    reader.onLoadEnd.listen((event) {
      completer.complete(reader.result as List<int>);
    });

    reader.readAsArrayBuffer(file);
    return completer.future;
  }

  Future<Response> login(String email, String password) async {
    final response = await _dio.post(
      '$baseUrl/login/email',
      data: {
        'email': email,
        'password': password,
      },
      // onSendProgress: (count, total) {
      //   log("send:$count");
      // },
      onReceiveProgress: (count, total) {
        log("recv:$count");
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = response.data;
      TokenStorage().setTokens(responseData['access'], responseData['refresh']);
    }
    return response;
  }

  // Create Content
  Future<Response> createContent(String title, String category,
      {html.File? thumbnail,
      html.File? description,
      int? points,
      String? introText}) async {
    String? token = TokenStorage().accessToken;

    if (token == null) {
      throw Exception('Token is not available');
    }

    final formDataMap = {
      'title': title,
      'category': category,
      if (points != null) 'points': points,
      if (introText != null) 'intro_text': introText,
    };

    if (thumbnail != null) {
      final thumbnailBytes = await _readFileAsBytes(thumbnail);
      formDataMap['thumbnail'] =
          MultipartFile.fromBytes(thumbnailBytes, filename: thumbnail.name);
    }

    if (description != null) {
      final descriptionBytes = await _readFileAsBytes(description);
      formDataMap['description'] =
          MultipartFile.fromBytes(descriptionBytes, filename: description.name);
    }

    FormData formData = FormData.fromMap(formDataMap);

    final response = await _dio.post(
      '$baseUrl/content/admin',
      data: formData,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    return response;
  }

  // List Content For Admin
  Future<Response> listContentForAdmin(
      String status, int offset, int limit) async {
    String? token = TokenStorage().accessToken;
    if (token == null) {
      throw Exception('Token is not available');
    }

    final response = await _dio.get(
      '$baseUrl/content/admin',
      queryParameters: {
        'status': status,
        'offset': offset,
        'limit': limit,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );
    return response;
  }

  // Update Content
  Future<Response> updateContent(
    int contentId, {
    String? title,
    html.File? description,
    html.File? thumbnail,
    int? points,
    String? introText,
    String? category,
    String? status,
    List<int>? firstQuestionList,
    List<html.File>? previews,
  }) async {
    String? token = TokenStorage().accessToken;

    if (token == null) {
      throw Exception('Token is not available');
    }

    final formDataMap = <String, dynamic>{
      if (title != null) 'title': title,
      if (points != null) 'points': points,
      if (introText != null) 'intro_text': introText,
      if (category != null) 'category': category,
      if (status != null) 'status': status,
      if (firstQuestionList != null)
        'first_question_list': jsonEncode(firstQuestionList),
    };

    if (description != null) {
      final descriptionBytes = await _readFileAsBytes(description);
      formDataMap['description'] = MultipartFile.fromBytes(
        descriptionBytes,
        filename: description.name,
      );
    }

    if (thumbnail != null) {
      final thumbnailBytes = await _readFileAsBytes(thumbnail);
      formDataMap['thumbnail'] = MultipartFile.fromBytes(
        thumbnailBytes,
        filename: thumbnail.name,
      );
    }

    if (previews != null) {
      for (int i = 0; i < previews.length; i++) {
        final previewBytes = await _readFileAsBytes(previews[i]);
        formDataMap['preview_${i + 1}'] = MultipartFile.fromBytes(
          previewBytes,
          filename: previews[i].name,
        );
      }
    }

    FormData formData = FormData.fromMap(
      formDataMap,
    );
    log(formData.fields.toString());

    final response = await _dio.put(
      '$baseUrl/content/admin',
      queryParameters: {'content_id': contentId},
      data: formData,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    return response;
  }

  // Create Question
  Future<Response> createQuestion(int contentId, String text) async {
    String? token = TokenStorage().accessToken;
    if (token == null) {
      throw Exception('Token is not available');
    }

    final response = await _dio.post(
      '$baseUrl/question/admin',
      data: {
        'content_id': contentId,
        'text': text,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );
    return response;
  }

  // List Question For Admin
  Future<Response> listQuestionForAdmin(
      int contentId, int offset, int limit) async {
    String? token = TokenStorage().accessToken;
    if (token == null) {
      throw Exception('Token is not available');
    }

    final response = await _dio.get(
      '$baseUrl/question/admin',
      queryParameters: {
        'content_id': contentId,
        'offset': offset,
        'limit': limit,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );
    return response;
  }

  // Create Answer
  Future<Response> createAnswer(int contentId, String text, int questionId,
      {int? nextQuestionId}) async {
    String? token = TokenStorage().accessToken;
    if (token == null) {
      throw Exception('Token is not available');
    }

    final response = await _dio.post(
      '$baseUrl/answer/admin',
      data: {
        'content_id': contentId,
        'text': text,
        'question_id': questionId,
        if (nextQuestionId != null) 'next_question_id': nextQuestionId,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );
    return response;
  }

  // List Answer For Admin
  Future<Response> listAnswerForAdmin(
      int contentId, int offset, int limit) async {
    String? token = TokenStorage().accessToken;
    if (token == null) {
      throw Exception('Token is not available');
    }

    final response = await _dio.get(
      '$baseUrl/answer/admin',
      queryParameters: {
        'content_id': contentId,
        'offset': offset,
        'limit': limit,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );
    return response;
  }
}
