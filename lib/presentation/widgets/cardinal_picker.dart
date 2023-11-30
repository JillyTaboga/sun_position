import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardinalPicker extends ConsumerStatefulWidget {
  const CardinalPicker({
    super.key,
    required this.changeAngle,
  });

  final void Function(double newAngle) changeAngle;

  @override
  ConsumerState<CardinalPicker> createState() => _CardinalPickerState();
}

class _CardinalPickerState extends ConsumerState<CardinalPicker> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      viewportFraction: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      onPageChanged: (value) {
        widget.changeAngle(value * 9);
      },
      children: List.generate(
        31,
        (index) {
          final angle = index * 9;
          final isCardinal = angle % 90 == 0;
          return Center(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: double.maxFinite,
                    width: 0.1,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  switch (index) {
                    0 => 'N',
                    10 => 'L',
                    20 => 'S',
                    30 => 'O',
                    _ => angle.toString(),
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isCardinal ? 16 : 9,
                    color: isCardinal ? Colors.black : Colors.black54,
                    fontWeight: isCardinal ? FontWeight.bold : FontWeight.w300,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Container(
                    height: double.maxFinite,
                    width: 0.1,
                    color: Colors.black,
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
