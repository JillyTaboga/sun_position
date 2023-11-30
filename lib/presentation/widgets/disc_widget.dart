import 'package:flutter/material.dart';
import 'package:sun_position/presentation/widgets/cardinal_letter.dart';

class DiscWidget extends StatelessWidget {
  const DiscWidget({
    super.key,
    required this.overlays,
    required this.isDark,
  });

  final List<Widget> overlays;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(10),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? Colors.black26 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
          ),
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox.square(
            dimension: constraints.maxWidth,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  margin: const EdgeInsets.all(2),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(25),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(50),
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
                ...overlays,
                const Align(
                  alignment: Alignment.topCenter,
                  child: CardinalLetter(
                    letter: 'N',
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: CardinalLetter(
                    letter: 'S',
                  ),
                ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: CardinalLetter(
                    letter: 'L',
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: CardinalLetter(
                    letter: 'O',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
