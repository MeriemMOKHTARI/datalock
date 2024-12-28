import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr("Conditions_Générales")),
      ),
     body: Container(
        color: Colors.white, // Arrière-plan blanc
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bienvenue
              Text(
                "Bienvenue sur notre application de livraison de nourriture. En utilisant notre service, vous acceptez les termes suivants".tr(),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),

              // Section 1
              Text(
               "1 Utilisation du Service".tr(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Vous acceptez de fournir des informations exactes lors de l'inscription.".tr(),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),

              // Section 2
              Text(
                tr("2_Commandes"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                tr("Une_fois_confirmées_,_les_commandes_ne_peuvent_pas_être_annulées_sauf_en_cas_de_force_majeure."),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              Text(
                tr("Les_restaurants_partenaires_sont_responsables_de_la_qualité_et_de_la_disponibilité_des_produits_commandés."),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),

              // Section 3
              Text(
                tr("3_Livraison"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                tr("La_livraison_est_assurée_uniquement_dans_les_zones_couvertes_par_notre_service."),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              Text(
                tr("Les_délais_de_livraison_sont_indicatifs_et_peuvent_varier_selon_les_conditions_locales."),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),

              // Section 4
              Text(
                tr("4_Prix_et_Paiement"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                tr("Tous_les_prix_incluent_les_taxes_applicables_en_Algérie."),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              Text(
                tr("Le_paiement_peut_être_effectué_en_ligne_ou_à_la_livraison_selon_les_options_disponibles."),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),

              // Section 5
              Text(
                tr("5_Droits_et_Responsabilités"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                tr("Nous_ne_sommes_pas_responsables_des_retards_pertes_ou_dommages_causés_par_des_événements_indépendants_de_notre_volonté."),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              Text(
                tr("Vous_acceptez_de_ne_pas_utiliser_l_application_à_des_fins_frauduleuses_ou_illégales."),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),

              // Section 6
              Text(
                tr("6_Modifications_des_Termes"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                tr("Nous_nous_réservons_le_droit_de_modifier_ces_conditions_à_tout_moment._Les_utilisateurs_seront_informés_des_changements_via_l_application."),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              SizedBox(height: 16),

              // Merci
              Text(
                tr("Merci_d_utiliser_notre_service_!"),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}