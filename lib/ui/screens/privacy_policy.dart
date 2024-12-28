import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Politique_de_Confidentialité'.tr()),
      ),
      body: Container(
        color: Colors.white, // Arrière-plan blanc
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1
              Text(
                "1_Données_Collectées".tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Données_Collectées_Contenu".tr(),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),

              // Section 2
              Text(
                "2_Utilisation_des_Données".tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Utilisation_des_Données_Contenu".tr(),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),

              // Section 3
              Text(
                "3_Partage_des_Données".tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Partage_des_Données_Contenu".tr(),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),

              // Section 4
              Text(
                "4_Sécurité_des_Données".tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Sécurité_des_Données_Contenu".tr(),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),

              // Section 5
              Text(
                "5_Conservation_des_Données".tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Conservation_des_Données_Contenu".tr(),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),

              // Section 6
              Text(
                "6_Droits_des_Utilisateurs".tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Droits_des_Utilisateurs_Contenu".tr(),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),

              // Section 7
              Text(
                "7_Modifications_de_la_Politique".tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Modifications_de_la_Politique_Contenu".tr(),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),

              // Closing
              Text(
                "Merci_de_votre_confiance".tr(),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}