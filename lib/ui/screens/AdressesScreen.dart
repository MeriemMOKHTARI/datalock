import 'package:datalock/services/map_service.dart';
import 'package:flutter/material.dart';
import '../../data/models/addresses_model.dart';
import 'MapScreen.dart';
import 'SaveAddressScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({Key? key}) : super(key: key);

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  List<Address> addresses = [];
bool _isLoading = true; // Added this variable
  final MapService _mapService = MapService(); 
  IconData _getIconData(String icon) {
    switch (icon) {
      case 'home':
        return Icons.home_outlined;
      case 'work':
        return Icons.work_outline;
      case 'school':
        return Icons.school_outlined;
      case 'star':
        return Icons.star_outline;
      case 'favorite':
        return Icons.favorite_outline;
      case 'location':
        return Icons.location_on_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  Color _getColor(String colorString) {
    switch (colorString) {
      case 'Colors.green':
        return Colors.green;
      case 'Colors.orange':
        return Colors.orange;
      case 'Colors.red':
        return Colors.red;
      case 'Colors.purple':
        return Colors.purple;
      case 'Colors.blue':
        return Colors.blue;
      case 'Colors.lightBlue':
        return Colors.lightBlue;
      default:
        return Colors.green;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
  setState(() {
    _isLoading = true;
  });

  final mapService = MapService();
  final result = await mapService.getFavoriteAddresses();
  
  if (result['status'] == '200') {
    setState(() {
      addresses = (result['data'] as List)
          .map((addr) => Address.fromMap(addr))
          .toList();
    });
  }
  
  setState(() {
    _isLoading = false;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Mes adresses',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF70B9BE)),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _buildAddressItem(
                        icon: Icons.navigation_outlined,
                        title: 'Position actuelle',
                        subtitle: 'Veuillez activer votre localisation',
                        showArrow: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MapScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      ...addresses.map((address) => Column(
                            children: [
                              _buildAddressItem(
                                icon: _getIconData(address.icon),
                                title: address.name,
                                subtitle:
                                    '${address.latitude.toStringAsFixed(6)}, ${address.longitude.toStringAsFixed(6)}',
                                showEdit: true,
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SaveAddressScreen(
                                        location: LatLng(
                                          address.latitude,
                                          address.longitude,
                                        ),
                                        addressToEdit: address,
                                      ),
                                    ),
                                  );

                                  if (result == true) {
                                    _loadAddresses(); // Reload addresses after edit
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MapScreen()),
                      );
                      if (result == true) {
                        _loadAddresses(); // Reload addresses after adding new one
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF88C3C6),
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Ajoutez une adresse',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
    

  Widget _buildAddressItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool showArrow = false,
    bool showEdit = false,
    Color color = Colors.green,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow)
              const Icon(Icons.arrow_forward_ios, size: 16)
            else if (showEdit)
              Icon(Icons.edit, color: color),
          ],
        ),
      ),
    );
  }
}