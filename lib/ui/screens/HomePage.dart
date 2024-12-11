import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './authentication_screen.dart';
import '../../config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> logout(BuildContext context) async {
    final storage = FlutterSecureStorage();
    final prefs = await SharedPreferences.getInstance();
    final account = Config.getAccount();
    final databases = Config.getDatabases();
    final functions = Config.getFunctions();

    try {
      // Delete user session data
      await storage.delete(key: 'phone_number');
      await storage.delete(key: 'user_id');

      // Reset language preference
      await prefs.remove('locale');

      print("User logged out and preferences reset.");
      
      // Navigate to the authentication screen after logout
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthenticationScreen(
          account: account,
          databases: databases,
          functions: functions,
        )),
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Adresse et filtre
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'HayStreet, Perth',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                    TextButton(
                      onPressed: () => logout(context),
                      child: const Text('Logout'),
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
                          image: AssetImage('assets/image.png'),
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
                      'All Restaurants',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'See all',
                      style: TextStyle(
                        color: Colors.orange,
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
                      name: 'Restaurant ${index + 1}',
                      address: 'Hay street, Perth City',
                      deliveryTime: '25min',
                      rating: 4.5,
                      isFreeDelivery: true,
                      imagePath: 'assets/BG${index + 1}.png',
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
                    image: AssetImage('assets/Banner.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromARGB(255, 206, 122, 11),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
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
    Key? key,
    required this.name,
    required this.address,
    required this.deliveryTime,
    required this.rating,
    required this.isFreeDelivery,
    required this.imagePath,
  }) : super(key: key);

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
                          color: Colors.orange,
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
                          'Free delivery',
                          style: TextStyle(
                            color: Colors.orange,
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

