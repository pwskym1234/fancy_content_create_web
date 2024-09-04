import 'package:fancy_content_creation_web/feature/home/logic/controller.dart';
import 'package:fancy_content_creation_web/feature/home/logic/update_content_logic.dart';
import 'package:fancy_content_creation_web/feature/home/widget/button.dart';
import 'package:fancy_content_creation_web/feature/home/widget/textfield.dart';
import 'package:fancy_content_creation_web/feature/update_page/logic/updateContentLogicv2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdatePage extends ConsumerStatefulWidget {
  const UpdatePage({Key? key}) : super(key: key);

  @override
  UpdatePageState createState() => UpdatePageState();
}

class UpdatePageState extends ConsumerState<UpdatePage> {
  Future<void> updateContent() async {
    await updateContentLogicv2(
      context: context,
      ref: ref,
    );
    ref.read(selectedQuestionIdsProvider.notifier).clearQuestionId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              'Update Content',
              style: TextStyle(fontSize: 24),
            ),
            Container(
              child: ContentIDTextField(),
              color: Colors.red,
            ),
            Container(
              child: QAListTextField(),
              color: Colors.amber,
            ),
            UpdateContentButton(onPressed: updateContent),
          ],
        ),
      ),
    );
  }
}
