import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sun_position/presentation/location_providers.dart';

part 'locatio_data_source.g.dart';

@riverpod
FutureOr<LatLong> location(LocationRef ref) async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw LocationErrors.notAvaible;
  }

  LocationPermission hasPermission = await Geolocator.checkPermission();
  if (hasPermission == LocationPermission.denied) {
    hasPermission = await Geolocator.requestPermission();
  }
  if (hasPermission == LocationPermission.denied ||
      hasPermission == LocationPermission.deniedForever) {
    throw LocationErrors.notPermited;
  }

  final location = await Geolocator.getCurrentPosition();
  return (location.latitude, location.longitude);
}

enum LocationErrors {
  notAvaible,
  notPermited,
  unknown,
}
