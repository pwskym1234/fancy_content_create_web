import 'package:fancy_content_creation_web/feature/home/logic/controller.dart';
import 'package:fancy_content_creation_web/feature/home/logic/fetch_logic.dart';
import 'package:fancy_content_creation_web/feature/home/widget/button.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContentQaView extends ConsumerWidget {
  const ContentQaView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentId = ref.watch(newContentIdFromResponseProvider);

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: 30),
                  Text(
                    'Content ID: $contentId',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Spacer(),
                  FetchContentButton(
                      onPressed: () => fetchQAData(context: context, ref: ref)),
                  SizedBox(width: 10),
                ],
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Column Content',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
