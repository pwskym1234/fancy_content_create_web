import 'dart:ui';

import 'package:fancy_content_creation_web/feature/home/logic/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QAView extends ConsumerStatefulWidget {
  const QAView({
    super.key,
  });

  @override
  QAViewState createState() => QAViewState();
}

class QAViewState extends ConsumerState<QAView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> layers = [];

    for (var group in ref.watch(groupedQADataProvider)) {
      var qa = group.first;
      layers.add(
        ListTile(
          title: Text(
            '${qa['question_text']} (ID: ${qa['question_id']})',
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255),
              backgroundColor: ref
                      .watch(selectedQuestionIdsProvider)
                      .contains(qa['question_id'])
                  ? const Color.fromARGB(255, 255, 59, 154)
                  : Colors.transparent,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => ref
              .watch(selectedQuestionIdsProvider.notifier)
              .updateQuestionId(qa['question_id']),
        ),
      );
      layers.add(
        ListTile(
          title: Text(qa['answer'] ?? '',
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
              )),
        ),
      );
      layers.add(const Divider(
          color: Color.fromARGB(255, 255, 255, 255), thickness: 1));
    }

    return Container(
      margin: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: layers,
          ),
        ),
      ),
    );
  }
}
