import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_calculator/solar_calculator.dart';
import 'package:sun_position/presentation/home_providers.dart';
import 'package:sun_position/presentation/location_providers.dart';
import 'package:sun_position/presentation/widgets/cardinal_picker.dart';
import 'package:sun_position/presentation/widgets/disc_widget.dart';
import 'package:sun_position/presentation/widgets/hour_picker.dart';
import 'package:sun_position/presentation/widgets/lat_long_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = ref.watch(orientationProvider);
    final orientationType = ref.watch(compassTypeProvider);
    final autoLocation = ref.watch(autoLocationProvider);
    final date = ref.watch(dateProvider);
    final lat = autoLocation is AutoLocationData ? autoLocation.data.$1 : 0.0;
    final long = autoLocation is AutoLocationData ? autoLocation.data.$2 : 0.0;
    final solarData = SolarCalculator(Instant.fromDateTime(date), lat, long);
    final solarAngle = solarData.sunHorizontalPosition.elevation.clamp(0, 90);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 450),
                turns: (orientation / 360) *
                    (orientationType == CompassTypeOrigin.auto ? -1 : -1),
                child: DiscWidget(
                  isDark: solarData.isHoursOfDarkness,
                  overlays: [
                    Transform.rotate(
                      angle: solarData.sunHorizontalPosition.azimuth * pi / 180,
                      child: Center(
                        child: Container(
                          width: 20,
                          height: double.maxFinite,
                          decoration: BoxDecoration(
                            color: solarData.isHoursOfDarkness
                                ? Colors.black12
                                : Colors.amber.withOpacity(0.2),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 1,
                                spreadRadius: 0,
                                blurStyle: BlurStyle.inner,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!solarData.isHoursOfDarkness)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Transform.rotate(
                            alignment: Alignment.center,
                            angle: solarData.sunHorizontalPosition.azimuth *
                                pi /
                                180,
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  SizedBox(height: (constraints.maxWidth) / 2),
                                  Expanded(
                                    child: Container(
                                      width: 35,
                                      height: double.maxFinite,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black54,
                                            Colors.transparent,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: constraints.maxWidth /
                                        2 *
                                        solarAngle /
                                        90,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    Center(
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: kElevationToShadow[4],
                        ),
                      ),
                    ),
                    if (!solarData.isHoursOfDarkness)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final solarDistance = (solarAngle /
                              90 *
                              ((constraints.maxWidth / 2) - 30));
                          return Transform.rotate(
                            angle: solarData.sunHorizontalPosition.azimuth *
                                pi /
                                180,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: solarDistance,
                                ),
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.75),
                                  shape: BoxShape.circle,
                                  boxShadow: kElevationToShadow[8],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 75,
            width: double.maxFinite,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const SizedBox(
                  width: 75,
                ),
                Expanded(
                  child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 5,
                          blurStyle: BlurStyle.inner,
                        ),
                      ],
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        HourPicker(
                          changeHour: (selectedHour) {
                            ref
                                .read(dateProvider.notifier)
                                .setHour(selectedHour);
                          },
                          startHour: date.hour,
                        ),
                        Center(
                          child: Container(
                            height: double.maxFinite,
                            width: 2,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              boxShadow: kElevationToShadow[2],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ref.invalidate(dateProvider);
                  },
                  child: const SizedBox(
                    width: 75,
                    child: Center(
                      child: Icon(Icons.refresh),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: orientationType == CompassTypeOrigin.manual
                ? Container(
                    height: 75,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            height: double.maxFinite,
                            width: double.maxFinite,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  blurStyle: BlurStyle.inner,
                                ),
                              ],
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                CardinalPicker(
                                  changeAngle: (newAngle) {
                                    ref
                                        .read(orientationProvider.notifier)
                                        .setManualAngle(newAngle);
                                  },
                                ),
                                Center(
                                  child: Container(
                                    height: double.maxFinite,
                                    width: 2,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      boxShadow: kElevationToShadow[2],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    toggleButtonsTheme: ToggleButtonsThemeData(
                      borderRadius: BorderRadius.circular(50),
                      constraints: const BoxConstraints(
                        minWidth: 100,
                        minHeight: 60,
                      ),
                      color: Colors.black45,
                      selectedColor: Colors.white,
                      selectedBorderColor: Colors.transparent,
                      fillColor: Colors.black26,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.03),
                          blurRadius: 5,
                          spreadRadius: 10,
                        ),
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.03),
                          blurRadius: 3,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ToggleButtons(
                      isSelected: CompassTypeOrigin.values
                          .map(
                            (e) => e == orientationType,
                          )
                          .toList(),
                      onPressed: (index) {
                        ref.read(compassTypeProvider.notifier).change();
                      },
                      children: const [
                        Text('Automático'),
                        Text('Manual'),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                LatLongWidget(autoLocation: autoLocation),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
