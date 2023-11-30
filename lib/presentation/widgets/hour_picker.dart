import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HourPicker extends ConsumerStatefulWidget {
  const HourPicker({
    super.key,
    required this.startHour,
    required this.changeHour,
  });

  final int startHour;
  final void Function(int selectedHour) changeHour;

  @override
  ConsumerState<HourPicker> createState() => _HourPickerState();
}

class _HourPickerState extends ConsumerState<HourPicker> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: widget.startHour,
      viewportFraction: 0.3,
    );
  }

  @override
  void didUpdateWidget(covariant HourPicker oldWidget) {
    if (widget.startHour != pageController.page?.round()) {
      Future(() {
        if (mounted) {
          pageController.jumpToPage(widget.startHour);
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      onPageChanged: (value) {
        widget.changeHour(value);
      },
      children: List.generate(
        24,
        (index) {
          final time = TimeOfDay(hour: index, minute: 0);
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  height: double.maxFinite,
                  width: 0.1,
                  color: Colors.black54,
                ),
                const SizedBox(
                  width: 10,
                ),
                Center(
                  child: Text(
                    '${time.hour}:00',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 11,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
