import 'package:datalock/ui/screens/HomePage.dart';
import 'package:flutter/material.dart';
import '../widgets/permission_card.dart';
import '../../services/permissions_service.dart';
import './city_selection_screen.dart';
import 'HomeContent.dart';
import '../../config/config.dart';
import 'package:easy_localization/easy_localization.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  _PermissionsScreenState createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  final PermissionsService _permissionsService = PermissionsService();
  final account = Config.getAccount();

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
                'Bienvenue!'.tr(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Config.themeData.primaryColor,
                  fontWeight: FontWeight.bold,
                  shadows: [
      Shadow(
        color: Colors.black26,
        offset: Offset(2, 2),
        blurRadius: 3,
      ),
    ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Pour_une_meilleure_experience,_nous_avons_besoin_de_votre_autorisation.'.tr(),
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
      title: 'Partager_votre_localisation'.tr(),
      description:
          'L_application_utilisera_votre_localisation_pour_trouver_des_établissements_près_de_vous,_et_vous_livrer_avec_prévision_à_votre_adresse.'.tr(),
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
      MaterialPageRoute(builder: (context) =>  HomePage()),
    );
  }
}

