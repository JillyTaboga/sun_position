import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sun_position/data/location_data/locatio_data_source.dart';

part 'location_providers.g.dart';

@riverpod
class AutoLocation extends _$AutoLocation {
  Timer? _time;

  @override
  AutoLocationState build() {
    ref.onDispose(() {
      cancel();
    });
    ref.onAddListener(() {
      _start();
    });
    return const AutoLocationLoading();
  }

  _start() {
    if (_time == null) _getLocation();
    _time = Timer.periodic(const Duration(seconds: 30), (timer) {
      _getLocation();
    });
  }

  cancel() {
    _time?.cancel();
  }

  _getLocation() async {
    try {
      final result = await ref.read(locationProvider.future);
      state = AutoLocationData(result);
    } catch (e) {
      final LocationErrors error = switch (e) {
        LocationErrors d => d,
        _ => LocationErrors.unknown,
      };
      state = AutoLocationError(error);
    }
  }
}

typedef LatLong = (double lat, double long);

sealed class AutoLocationState {
  const AutoLocationState();
}

final class AutoLocationError extends AutoLocationState {
  const AutoLocationError(this.error);
  final LocationErrors error;
}

final class AutoLocationData extends AutoLocationState {
  const AutoLocationData(this.data);
  final LatLong data;
}

final class AutoLocationLoading extends AutoLocationState {
  const AutoLocationLoading();
}
