import 'package:fancy_content_creation_web/feature/home/logic/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QAView extends ConsumerStatefulWidget {
  final List<Map<dynamic, dynamic>> qaData;

  const QAView({
    super.key,
    required this.qaData,
  });

  @override
  QAViewState createState() => QAViewState();
}

class QAViewState extends ConsumerState<QAView> {
  List<int> selectedQuestionIds = [];

  @override
  void initState() {
    super.initState();
  }

  void _onQuestionTap(int questionId) {
    setState(() {
      if (selectedQuestionIds.contains(questionId)) {
        selectedQuestionIds.remove(questionId);
      } else {
        selectedQuestionIds.add(questionId);
      }
      ref
          .read(selectedQuestionIdsProvider.notifier)
          .updateQuestionId(selectedQuestionIds);
    });
  }

  void _deselectAllQuestions() {
    setState(() {
      selectedQuestionIds.clear();
      ref
          .read(selectedQuestionIdsProvider.notifier)
          .updateQuestionId(selectedQuestionIds);
    });
  }

  void _selectAllQuestions() {
    setState(() {
      selectedQuestionIds = ref
          .watch(groupedQADataProvider)
          .where((group) => group.isNotEmpty)
          .map<int>((group) => group.first['question_id'] as int)
          .toList();
      ref
          .read(selectedQuestionIdsProvider.notifier)
          .updateQuestionId(selectedQuestionIds);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> layers = [];

    for (var qa in ref.watch(fetchedAnswerQuestionMapProvider)) {
      ref.read(currentGroupProvider.notifier).addQAData(qa);
      if (qa['next_question_id'] == '' && qa['next_question_text'] == '') {
        ref
            .read(groupedQADataProvider.notifier)
            .addGroupedQAData(ref.watch(currentGroupProvider));
        ref.read(currentGroupProvider.notifier).clearQAData();
      }
    }

    if (ref.watch(currentGroupProvider).isNotEmpty) {
      ref
          .read(groupedQADataProvider.notifier)
          .addGroupedQAData(ref.watch(currentGroupProvider));
    }

    debugPrint("Received qaData: ${widget.qaData}");

    debugPrint(
        "Number of created groups: ${ref.watch(groupedQADataProvider).length}");

    for (var group in ref.watch(groupedQADataProvider)) {
      var qa = group.first;
      layers.add(
        ListTile(
          title: Text(
            '${qa['question_text']} (ID: ${qa['question_id']})',
            style: TextStyle(
              color: Colors.black,
              backgroundColor: selectedQuestionIds.contains(qa['question_id'])
                  ? Colors.yellow
                  : Colors.transparent,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: const Icon(Icons.question_answer),
          onTap: () => _onQuestionTap(qa['question_id']),
        ),
      );
      layers.add(
        ListTile(
          title: Text(
            qa['answer'] ?? '',
          ),
          leading: const Icon(Icons.arrow_forward),
        ),
      );
      layers.add(const Divider(color: Colors.blue, thickness: 2));
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: _selectAllQuestions,
          ),
          IconButton(
            icon: const Icon(Icons.deselect),
            onPressed: _deselectAllQuestions,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: layers,
      ),
    );
  }
}
