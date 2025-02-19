import 'package:appwrite/appwrite.dart';
import 'package:datalock/ui/screens/HomePage.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import 'HomeContent.dart';
import '../../config/config.dart';
import 'package:easy_localization/easy_localization.dart';

class CitySelectionScreen extends StatefulWidget {
  const CitySelectionScreen({super.key});

  @override
  _CitySelectionScreenState createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  String? _selectedCity;
 final List<String> _algerianCities = [
  'Adrar', 'Aïn Defla', 'Aïn Témouchent', 'Alger', 'Annaba', 'Batna', 'Béchar', 
  'Béjaïa', 'Biskra', 'Blida', 'Bordj Bou Arreridj', 'Bouira', 'Boumerdès', 'Chlef',
  'Constantine', 'Djelfa', 'El Bayadh', 'El Oued', 'El Tarf', 'Ghardaïa', 
  'Guelma', 'Illizi', 'Jijel', 'Khenchela', 'Laghouat', 'Mascara', 'Médéa', 
  'Mila', 'Mostaganem', 'Msila', 'Naâma', 'Oran', 'Ouargla', 'Oum El Bouaghi',
  'Relizane', 'Saïda', 'Sétif', 'Sidi Bel Abbès', 'Skikda', 'Souk Ahras', 
  'Tamanghasset', 'Tébessa', 'Tiaret', 'Tindouf', 'Tipaza', 'Tissemsilt', 
  'Tizi Ouzou', 'Tlemcen'
];
  final account = Config.getAccount();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text('select_your_city'.tr()),
        backgroundColor: Config.themeData.primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Veuillez_sélectionner_votre_ville'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Config.themeData.scaffoldBackgroundColor,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedCity,
                hint:  Text('choose_a_city'.tr()),
                isExpanded: true,
                items: _algerianCities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCity = newValue;
                  });
                  if (newValue != null && newValue != 'Oran') {
                    _showCityAlert();
                  }
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: _selectedCity != null ? _handleCityConfirmation : null,
                text: 'confirm_city'.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCityAlert() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('service_unavailable'.tr()),
        content: Text('service_only_in_oran'.tr()),
        actions: <Widget>[
          TextButton(
            child:  Text('OK'.tr()),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                // Reset the selected city to Oran after the alert
                _selectedCity = 'Oran'; 
              });
            },
          ),
        ],
      );
    },
  );
}

void _handleCityConfirmation() {
  if (_selectedCity == 'Oran') {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) =>  HomePage()),
    );
  } else {
    _showCityAlert();
  }
}
}