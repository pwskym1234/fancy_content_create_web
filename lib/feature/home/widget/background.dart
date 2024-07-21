import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 첫 번째 공
        Positioned(
          right: 450,
          bottom: -30,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  Color.fromARGB(255, 255, 63, 10),
                  Color.fromARGB(255, 255, 164, 18),
                ],
                center: Alignment(-0.3, -0.3),
                focal: Alignment(-0.1, -0.1),
                focalRadius: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(10, 10),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
        // 두 번째 공 (오른쪽 위)
        Positioned(
          right: -20,
          top: -20,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  Color.fromARGB(255, 0, 150, 255),
                  Color.fromARGB(255, 0, 200, 255),
                ],
                center: Alignment(-0.3, -0.3),
                focal: Alignment(-0.1, -0.1),
                focalRadius: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(10, 10),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
        // 세 번째 공 (왼쪽 중간)
        Positioned(
          left: -40,
          top: MediaQuery.of(context).size.height / 3,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  Color.fromARGB(255, 38, 1, 170),
                  Color.fromARGB(255, 132, 10, 255),
                ],
                center: Alignment(-0.3, -0.3),
                focal: Alignment(-0.1, -0.1),
                focalRadius: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(10, 10),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
