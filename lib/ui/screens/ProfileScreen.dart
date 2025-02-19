import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'PersonalProfileScreen.dart';
import 'AdressesScreen.dart';
import 'NotificationsScreen.dart';
import '../widgets/ProfileMenuItem.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header Section
            Row(
              children: [
                Icon(CupertinoIcons.sun_max, color: Color(0xFF70B9BE)),
                const SizedBox(width: 8),
                Text(
                  'Bonjour',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Okba GHODBANI',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Profile Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Mon profil',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PersonalProfileScreen(),
                      ),
                    ),
                  ),
                  ProfileMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Mes adresses',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddressesScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Partner Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.store_outlined,
                    title: 'Devenir partenaire',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.delivery_dining_outlined,
                    title: 'Devenir livreur',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Other Options Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Mes commandes',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.favorite_outline,
                    title: 'Mes favoris',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsScreen(),
                      ),
                    ),
                  ),
                  ProfileMenuItem(
                    icon: Icons.language_outlined,
                    title: 'Langues',
                    onTap: () {},
                  ),
                  ProfileMenuItem(
                    icon: Icons.card_giftcard_outlined,
                    title: 'Invitez & Gagnez',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            TextButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.logout,
                color: Colors.red[400],
              ),
              label: Text(
                'Se déconnecter',
                style: TextStyle(
                  color: Colors.red[400],
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}