import 'dart:ui';

import 'package:fancy_content_creation_web/data/api_service.dart';
import 'package:fancy_content_creation_web/feature/home/logic/controller.dart';
import 'package:fancy_content_creation_web/feature/home/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ControlListView extends ConsumerWidget {
  const ControlListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentList = ref.watch(contentListProvider);
    final selectedState = ref.watch(selectedStateProvider);

    // Filter the content list based on the selected state
    final filteredContentList = contentList;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white),
      ),
      margin: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Column(
            children: [
              // Single button for toggling the state
              SelectListButton(
                onPressed: () {
                  final currentState = ref.watch(selectedStateProvider);
                  final nextState = currentState == 'ACTIVE'
                      ? 'INACTIVE'
                      : currentState == 'INACTIVE'
                          ? 'PREPARING'
                          : 'ACTIVE';
                  ref.watch(selectedStateProvider.notifier).state = nextState;
                  ref
                      .watch(contentListProvider.notifier)
                      .fetchContentList(nextState);
                },
                text: '$selectedState',
              ),
              const SizedBox(height: 10),
              // Display the content list
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var content in filteredContentList)
                        ListTile(
                          title: Text(
                            content.title,
                            maxLines: 1,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'ID: ${content.id}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () async {
                              await ref
                                  .watch(apiServiceProvider)
                                  .deleteContent(content.id);
                              ref
                                  .watch(contentListProvider.notifier)
                                  .fetchContentList(selectedState);
                            },
                          ),
                        ),
                    ],
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
