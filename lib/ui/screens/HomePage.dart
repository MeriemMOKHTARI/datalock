import 'package:flutter/material.dart';
import '../widgets/permission_card.dart';
import '../../services/permissions_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PermissionsService _permissionsService = PermissionsService();
  bool _showNotificationPermission = true;

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
                         const Text(
                             "Hello \n Okba Ghodbani",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        const Row(
                          children: [
                            Text(
                              "Oran , Algeria",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
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
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0,left: 16.0,right: 16.0,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "All stores",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                           "see all",
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
                          address: 'Oran',
                          deliveryTime: '25min',
                          rating: 4.5,
                          isFreeDelivery: true,
                          
                          imagePath: index % 2 == 0 ? 'assets/images/BG1.jpg' : 'assets/images/BG2.jpeg',
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
                title: 'Autorisation de notifications',
                description: 'Recevez des notifications sur vos commandes et offres spéciales',
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
             label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
             label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label:"commands",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
             label: "Profil",
          ),
        ],
      ),
    );
  }

void _handleNotificationPermission() async {
  bool granted = await _permissionsService.requestNotificationPermission();
  if (mounted) {  // Vérifier si le widget est toujours monté
    setState(() {
      _showNotificationPermission = false;
    });
  }
}

void _handleNotificationDenied() {
  if (mounted) {  // Vérifier si le widget est toujours monté
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
                      if (isFreeDelivery)
                        const Text(
                          "Free delivery",
                          style: TextStyle(
                            color: Color.fromARGB(255, 30, 91, 99),
                          ),
                        ),
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

