import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class PermissionsService {
  Future<bool> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();
    // Attendre un court instant pour permettre au système de traiter la demande
    await Future.delayed(const Duration(milliseconds: 500));
    return status.isGranted;
  }

  Future<bool> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      // Attendre un court instant pour permettre au système de traiter la demande
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      print('Erreur lors de la demande de permission de localisation: $e');
      return false;
    }
  }

  Future<bool> checkNotificationPermission() async {
    return await Permission.notification.isGranted;
  }
}