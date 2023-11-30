import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'permissions.g.dart';

@riverpod
FutureOr<bool> permission(PermissionRef ref) async {
  final resultLocation = await Permission.locationWhenInUse.status;
  final resultSensors = await Permission.sensors.status;
  return resultLocation.isGranted && resultSensors.isGranted;
}
