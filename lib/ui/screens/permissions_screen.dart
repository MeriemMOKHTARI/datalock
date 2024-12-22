import 'package:flutter/material.dart';
import '../widgets/permission_card.dart';
import '../../services/permissions_service.dart';
import './city_selection_screen.dart';
import './HomePage.dart';
import '../../config/config.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  _PermissionsScreenState createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  final PermissionsService _permissionsService = PermissionsService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bienvenue !',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Config.themeData.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pour une meilleure expérience, nous avons besoin de votre autorisation.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Config.themeData.scaffoldBackgroundColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _buildLocationPermission(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationPermission() {
    return PermissionCard(
      title: 'Autorisation de géolocalisation',
      description:
          'Nous avons besoin de votre localisation pour vous montrer les restaurants à proximité',
      icon: Icons.location_on,
      onAccept: _handleLocationPermission,
      onDeny: _handleLocationDenied,
    );
  }

  void _handleLocationPermission() async {
    bool hasPermission = await _permissionsService.requestLocationPermission();
    if (hasPermission) {
      _navigateToHomePage();
    } else {
      _navigateToCitySelection();
    }
  }

  void _handleLocationDenied() {
    _navigateToCitySelection();
  }

  void _navigateToCitySelection() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const CitySelectionScreen()),
    );
  }
  
  void _navigateToHomePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}

