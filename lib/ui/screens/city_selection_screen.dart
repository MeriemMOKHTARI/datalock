import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import './HomePage.dart';
import '../../config/config.dart';

class CitySelectionScreen extends StatefulWidget {
  const CitySelectionScreen({super.key});

  @override
  _CitySelectionScreenState createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  String? _selectedCity;
  final List<String> _algerianCities = [
    'Alger', 'Oran', 'Constantine', 'Annaba', 'Blida', 'Batna', 'Djelfa', 'Sétif', 'Sidi Bel Abbès', 'Biskra'
  ]; // Add more cities as needed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sélectionnez votre ville'),
        backgroundColor: Config.themeData.primaryColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Veuillez sélectionner votre ville',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Config.themeData.scaffoldBackgroundColor,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedCity,
                hint: const Text('Choisissez une ville'),
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
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: _selectedCity != null ? _handleCityConfirmation : null,
                text: 'Confirmer la ville',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCityConfirmation() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}

