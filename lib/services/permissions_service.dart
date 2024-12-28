import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionsService {
  Future<bool> requestNotificationPermission() async {
    final prefs = await SharedPreferences.getInstance();
    bool alreadyRequested = prefs.getBool('notification_permission_requested') ?? false;

    if (alreadyRequested) {
      // Si déjà demandé, ne pas redemander
      return await checkNotificationPermission();
    }

    // Sinon, demander l'autorisation
    PermissionStatus status = await Permission.notification.request();
    await Future.delayed(const Duration(milliseconds: 500));

    // Stocker que la permission a été demandée
    prefs.setBool('notification_permission_requested', true);

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
