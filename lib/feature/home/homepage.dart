import 'package:fancy_content_creation_web/feature/home/logic/controller.dart';
import 'package:fancy_content_creation_web/feature/home/logic/create_content_logic.dart';
import 'package:fancy_content_creation_web/feature/home/logic/login_logic.dart';
import 'package:fancy_content_creation_web/feature/home/logic/update_content_logic.dart';
import 'package:fancy_content_creation_web/feature/home/widget/background.dart';
import 'package:fancy_content_creation_web/feature/home/widget/button.dart';
import 'package:fancy_content_creation_web/feature/home/content_QA_view/content_QA_view.dart';
import 'package:fancy_content_creation_web/%08widgets/glassmorphicContainer.dart';
import 'package:fancy_content_creation_web/feature/home/widget/textfield.dart';
import 'package:fancy_content_creation_web/%08widgets/custom_buttons.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  List<int> selectedQuestionIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      login();
    });
  }

  Future<void> login() async {
    await ref.read(logInProvider).login(context);
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> createContent() async {
    await createContentLogic(
      context: context,
      ref: ref,
    );
    ref.read(qaListControllerProvider.notifier).clear();
  }

  Future<void> updateContent() async {
    await updateContentLogic(
      context: context,
      ref: ref,
    );
    ref.read(selectedQuestionIdsProvider.notifier).clearQuestionId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Background(),
          Positioned.fill(
            right: 0,
            left: MediaQuery.of(context).size.width / 2,
            child: const ContentQaView(),
          ),
          // Scrollable left column
          Positioned.fill(
            left: 0,
            right: MediaQuery.of(context).size.width / 2,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Content title
                    GlassmorphicContainer(
                      child: ContentTitleTextField(),
                    ),
                    SizedBox(height: 20),
                    // Row 1
                    Row(
                      children: [
                        Expanded(
                          child: GlassmorphicContainer(
                            child: ContentIDTextField(),
                          ),
                        ),
                        const SizedBox(width: 20),
                        CustomToggleButtonTwoStates(
                          height: 60,
                          width: 140,
                        ),
                        const SizedBox(width: 20),
                        CustomToggleButtonFourStates(
                          height: 60,
                          width: 140,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Row 2 with three buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PickThumbnailButton(),
                        PickDescriptionButton(),
                        PickPreviewButton(
                          file: null,
                        ),
                        // Add a preview display here if needed
                        if (ref.watch(previewProvider).isNotEmpty)
                          Column(
                            children: ref.watch(previewProvider).map((file) {
                              return Text(file
                                  .name); // Example of displaying file names
                            }).toList(),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Content intro text
                    GlassmorphicContainer(
                      child: ContentIntroTextField(),
                    ),
                    const SizedBox(height: 20),
                    // Question and Answer list
                    GlassmorphicContainer(
                      child: QAListTextField(),
                    ),
                    const SizedBox(height: 20),
                    // Row 3 with two buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CreateContentButton(onPressed: createContent),
                        UpdateContentButton(onPressed: updateContent),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
