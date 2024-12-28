import 'package:appwrite/appwrite.dart';
import 'package:datalock/config/config.dart';
import 'package:datalock/services/auth_service.dart';
import 'package:datalock/ui/screens/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/permission_card.dart';
import '../../services/permissions_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PermissionsService _permissionsService = PermissionsService();
  bool _showNotificationPermission = true;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final account = Config.getAccount();
  final databases = Config.getDatabases();
  final functions = Config.getFunctions();

  @override
  void initState() {
    super.initState();
    _checkNotificationPermissionStatus();
  }

  Future<void> _checkNotificationPermissionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool alreadyRequested =
        prefs.getBool('notification_permission_requested') ?? false;

    if (mounted) {
      setState(() {
        _showNotificationPermission = !alreadyRequested;
      });
    }
  }

  Future<void> logout() async {
    try {
      await storage.delete(key: 'session_id');
      await storage.delete(key: 'phone_number');
      await storage.delete(key: 'new_user_id');
    } catch (e) {
      print('Error saving user session: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Adresse et filtre
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hello".tr(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Oran_,_Algeria".tr(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                        TextButton(
                            onPressed: () async {
                              final authService = AuthService();
                              String session_ID = await storage
                                  .read(key: 'session_id')
                                  .toString();
                              Map<String, String> result = await authService
                                  .logoutUser(session_ID, account, databases);
                              if (result['status'] == '200') {
                                await logout();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => AuthenticationScreen(
                                      account: Account(Client()),
                                      databases: Databases(Client()),
                                      functions: Functions(Client()),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Icon(Icons.logout) //////////LOGOUT
                            ),
                      ],
                    ),
                  ),

                  // Liste défilante horizontale des plats populaires
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 480,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/banner2.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Titre "All Restaurants"
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "All_stores".tr(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "see_all".tr(),
                          style: TextStyle(
                            color: Color.fromARGB(255, 2, 32, 30),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Liste défilante horizontale des restaurants
                  SizedBox(
                    height: 230,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return RestaurantCard(
                          name: 'Magasin ${index + 1}',
                          address: 'Oran'.tr(),
                          deliveryTime: '25min'.tr(),
                          rating: 4.5,
                          isFreeDelivery: true,
                          imagePath: index % 2 == 0
                              ? 'assets/images/BG1.jpg'
                              : 'assets/images/BG2.jpg',
                        );
                      },
                    ),
                  ),

                  // Bannière promotionnelle
                  Container(
                    height: 200,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/Banner.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showNotificationPermission)
            Center(
              child: PermissionCard(
                title: 'Autorisation_de_notifications'.tr(),
                description:
                    'Recevez_des_notifications_sur_vos_commandes_et_offres_spéciales'
                        .tr(),
                icon: Icons.notifications,
                onAccept: _handleNotificationPermission,
                onDeny: _handleNotificationDenied,
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(110, 25, 145, 175),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: "Orders".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile".tr(),
          ),
        ],
      ),
    );
  }

  void _handleNotificationPermission() async {
    bool granted = await _permissionsService.requestNotificationPermission();
    if (mounted) {
      setState(() {
        _showNotificationPermission = false;
      });
    }

    if (!granted) {
      _handleNotificationDenied();
    }
  }

  void _handleNotificationDenied() {
    if (mounted) {
      setState(() {
        _showNotificationPermission = false;
      });
    }
  }
}

class RestaurantCard extends StatelessWidget {
  final String name;
  final String address;
  final String deliveryTime;
  final double rating;
  final bool isFreeDelivery;
  final String imagePath;

  const RestaurantCard({
    super.key,
    required this.name,
    required this.address,
    required this.deliveryTime,
    required this.rating,
    required this.isFreeDelivery,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.all(8),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du restaurant
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    address,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x0070b9be),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(
                              rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(deliveryTime),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
