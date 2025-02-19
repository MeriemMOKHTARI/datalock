import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/permission_card.dart';
import '../../services/permissions_service.dart';
import '../../services/auth_service.dart';
import '../../config/config.dart';
import '../screens/authentication_screen.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  final PermissionsService _permissionsService = PermissionsService();
  bool _showNotificationPermission = true;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final account = Config.getAccount();
  final databases = Config.getDatabases();
  final functions = Config.getFunctions();
  late AuthService _authService;
  int _selectedIndex = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _checkNotificationPermissionStatus();
    _saveSession();
     _animationController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  }

@override
void dispose() {
  _animationController.dispose();
  super.dispose();
}

  Future<void> _checkNotificationPermissionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool alreadyRequested = prefs.getBool('notification_permission_requested') ?? false;
    if (mounted) {
      setState(() {
        _showNotificationPermission = !alreadyRequested;
      });
    }
  }

  Future<void> _saveSession() async {
    final sessionID = await storage.read(key: 'session_id');
    if (sessionID == null) {
      final id = await storage.read(key: 'new_user_id');
      final phoneNumber = await storage.read(key: 'phoneNumber');
      if (id != null && phoneNumber != null) {
        _authService.uploadUserSession(phoneNumber, id, account, databases);
      }
    }
  }

  Future<void> logout() async {
    try {
      await storage.delete(key: 'session_id');
      await storage.delete(key: 'phone_number');
      await storage.delete(key: 'new_user_id');
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildPopularSection(),
                        _buildNewStoresSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_showNotificationPermission) _buildPermissionCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello".tr(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Find_your_favorite_store".tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Color(0xFF6B7280)),
                        const SizedBox(width: 4),
                        Text(
                          "Oran_,_Algeria".tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF6B7280)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () async {
                        bool confirmLogout = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirmation".tr()),
                              content: Text("Êtes-vous sûr de vouloir vous déconnecter ?".tr()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text("Non".tr()),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text("Oui".tr()),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmLogout == true) {
                          final sessionID = await storage.read(key: 'session_id');
                          if (sessionID != null) {
                            Map<String, String> result = await _authService.logoutUser(
                              sessionID,
                              account,
                              databases,
                            );
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
                          }
                        }
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Color(0xFF6B7280),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFF6B7280)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search".tr(),
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Popular_stores".tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "see_all".tr(),
                  style: const TextStyle(
                    color:  const Color(0xFF70B9BE)
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return StoreCard(
                name: 'Store ${index + 1}',
                image: 'assets/images/BG${index % 2 + 1}.jpg',
                rating: 4.5,
                category: 'Category ${index + 1}',
                width: 200,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewStoresSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "New_stores".tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return StoreCard(
              name: 'Store ${index + 1}',
              image: 'assets/images/BG${index % 2 + 1}.jpg',
              rating: 4.5,
              category: 'Category ${index + 1}',
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.15),
          blurRadius: 20,
          spreadRadius: 1,
        ),
      ],
    ),
    child: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, Icons.home, 0, "Home"),
            _buildNavItem(Icons.search_outlined, Icons.search, 1, "Search"),
            _buildNavItem(Icons.notifications_none_outlined, Icons.notifications, 2, "Notifications"),
            _buildNavItem(Icons.person_outline_outlined, Icons.person, 3, "Profile"),
          ],
        ),
      ),
    ),
  );
}
  Widget _buildNavItem(IconData outlinedIcon, IconData filledIcon, int index, String label) {
  final isSelected = _selectedIndex == index;
  return GestureDetector(
    onTap: () {
      setState(() {
        _selectedIndex = index;
      });
      _animationController.forward(from: 0);
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color.fromARGB(255, 5, 4, 32).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isSelected ? filledIcon : outlinedIcon,
              key: ValueKey<bool>(isSelected),
              color: isSelected ? const Color.fromARGB(255, 5, 4, 32) : const Color(0xFF6B7280),
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.tr(),
            style: TextStyle(
              fontSize: 12,
              color: isSelected ?const Color.fromARGB(255, 5, 4, 32) : const Color(0xFF6B7280),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _buildPermissionCard() {
    return Center(
      child: PermissionCard(
        title: "Autorisation_de_notifications".tr(),
        description: "Recevez_des_notifications_sur_vos_commandes_et_offres_spéciales".tr(),
        icon: Icons.notifications,
        onAccept: _handleNotificationPermission,
        onDeny: _handleNotificationDenied,
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

class StoreCard extends StatelessWidget {
  final String name;
  final String image;
  final double rating;
  final String category;
  final double? width;

  const StoreCard({
    Key? key,
    required this.name,
    required this.image,
    required this.rating,
    required this.category,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color:  const Color(0xFF70B9BE),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color:  const Color(0xFF70B9BE)
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}