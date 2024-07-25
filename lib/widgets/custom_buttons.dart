import 'package:fancy_content_creation_web/feature/home/logic/controller.dart';
import 'package:fancy_content_creation_web/feature/home/logic/small_logics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final Gradient strokeGradient;
  final Color color;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.height,
    required this.width,
    required this.strokeGradient,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        gradient: strokeGradient,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.7), // Lighter shadow
            offset: const Offset(0, 0), // Shadow position
            blurRadius: 8, // Shadow blur radius
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(1), // For stroke thickness
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius:
              BorderRadius.circular(100), // Adjust based on the margin
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomToggleButtonTwoStates extends ConsumerStatefulWidget {
  final double height;
  final double width;

  const CustomToggleButtonTwoStates({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  CustomToggleButtonTwoStatesState createState() =>
      CustomToggleButtonTwoStatesState();
}

class CustomToggleButtonTwoStatesState
    extends ConsumerState<CustomToggleButtonTwoStates> {
  @override
  Widget build(BuildContext context) {
    final status = ref.watch(statusProvider);
    return CustomButton(
      text: status == 'ACTIVE' ? 'ACTIVE' : 'INACTIVE',
      onPressed: () {
        setState(() {
          final newStatus = status == 'ACTIVE' ? 'INACTIVE' : 'ACTIVE';
          updateStatusLogic(context, ref, newStatus);
        });
      },
      height: widget.height,
      width: widget.width,
      color: status == 'ACTIVE'
          ? const Color.fromARGB(255, 11, 231, 18)
          : const Color.fromARGB(255, 255, 66, 28),
      strokeGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color.fromARGB(255, 215, 215, 215),
          status == 'ACTIVE'
              ? const Color.fromARGB(255, 11, 231, 18)
              : const Color.fromARGB(255, 255, 66, 28),
          const Color.fromARGB(255, 87, 0, 208),
        ],
      ),
    );
  }
}

class CustomToggleButtonFourStates extends ConsumerStatefulWidget {
  final double height;
  final double width;

  const CustomToggleButtonFourStates({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  CustomToggleButtonFourStatesState createState() =>
      CustomToggleButtonFourStatesState();
}

class CustomToggleButtonFourStatesState
    extends ConsumerState<CustomToggleButtonFourStates> {
  int toggleState = 0;
  final List<String> categories = ['LOVE', 'FRIENDSHIP', 'SELF', 'WORK'];

  final List<Color> categoryColors = [
    const Color.fromARGB(255, 255, 136, 243),
    const Color.fromARGB(255, 117, 193, 255),
    const Color.fromARGB(255, 134, 73, 255),
    const Color.fromARGB(255, 255, 208, 138),
  ]; // Colors for each state

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: categories[toggleState],
      onPressed: () {
        setState(() {
          toggleState = (toggleState + 1) % categories.length;
          updateCategoryLogic(context, ref, categories[toggleState]);
        });
      },
      height: widget.height,
      width: widget.width,
      color: categoryColors[toggleState],
      strokeGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color.fromARGB(255, 255, 255, 255),
          categoryColors[toggleState],
          categoryColors[toggleState],
          const Color.fromARGB(255, 0, 0, 0),
        ],
      ), // Gradient colors for stroke
    );
  }
}

class AverageRatingButtonFourStates extends ConsumerStatefulWidget {
  final double height;
  final double width;

  const AverageRatingButtonFourStates({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  AverageRatingButtonFourStatesState createState() =>
      AverageRatingButtonFourStatesState();
}

class AverageRatingButtonFourStatesState
    extends ConsumerState<AverageRatingButtonFourStates> {
  int toggleState = 0;
  final List<double> categories = [4.8, 4.5, 4.3, 4.1];

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: categories[toggleState].toString(),
      onPressed: () {
        setState(() {
          toggleState = (toggleState + 1) % categories.length;
          updateAverageRatingLogic(context, ref, categories[toggleState]);
        });
      },
      height: widget.height,
      width: widget.width,
      color: const Color.fromARGB(255, 255, 255, 255),
      strokeGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color.fromARGB(255, 255, 255, 255),
          const Color.fromARGB(255, 0, 0, 0),
        ],
      ), // Gradient colors for stroke
    );
  }
}

class WordCountButtonFourStates extends ConsumerStatefulWidget {
  final double height;
  final double width;

  const WordCountButtonFourStates({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  WordCountButtonFourStatesState createState() =>
      WordCountButtonFourStatesState();
}

class WordCountButtonFourStatesState
    extends ConsumerState<WordCountButtonFourStates> {
  int toggleState = 0;
  final List<int> categories = [400, 800, 500, 300];

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: categories[toggleState].toString(),
      onPressed: () {
        setState(() {
          toggleState = (toggleState + 1) % categories.length;
          updateWordCountLogic(context, ref, categories[toggleState]);
        });
      },
      height: widget.height,
      width: widget.width,
      color: const Color.fromARGB(255, 255, 255, 255),
      strokeGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color.fromARGB(255, 255, 255, 255),
          const Color.fromARGB(255, 0, 0, 0),
        ],
      ), // Gradient colors for stroke
    );
  }
}
