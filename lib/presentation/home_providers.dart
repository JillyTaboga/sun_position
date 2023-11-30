import 'dart:async';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_providers.g.dart';

@riverpod
class Orientation extends _$Orientation {
  StreamSubscription? _autoSubscription;
  DateTime _lastUpdate = DateTime.now();

  @override
  double build() {
    return 0;
  }

  startAutoOrientation() async {
    try {
      _autoSubscription = FlutterCompass.events!.listen((event) {
        if ((DateTime.now().difference(_lastUpdate).inMilliseconds > 200) &&
            event.heading != state) {
          state = event.heading ?? 0;
          _lastUpdate = DateTime.now();
        }
      });
    } catch (e) {
      ref.read(compassTypeProvider.notifier).change();
    }
  }

  cancelAutoOrientation() {
    _autoSubscription?.cancel();
    state = 0;
  }

  setManualAngle(double angle) {
    state = angle;
  }
}

@riverpod
class CompassType extends _$CompassType {
  @override
  CompassTypeOrigin build() {
    return CompassTypeOrigin.manual;
  }

  change() {
    if (state == CompassTypeOrigin.manual) {
      ref.read(orientationProvider.notifier).startAutoOrientation();
      state = CompassTypeOrigin.auto;
    } else {
      ref.read(orientationProvider.notifier).cancelAutoOrientation();
      state = CompassTypeOrigin.manual;
    }
  }
}

@riverpod
class Date extends _$Date {
  @override
  DateTime build() {
    return DateTime.now();
  }

  setHour(int newHour) {
    state = state.copyWith(hour: newHour);
  }
}

enum CompassTypeOrigin {
  auto,
  manual,
}
