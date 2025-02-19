import 'package:flutter/material.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mes adresses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF70B9BE), ),      onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
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
                ),
                const SizedBox(height: 16),
                _buildAddressItem(
                  icon: Icons.home_outlined,
                  title: 'maison',
                  subtitle: '35°700, -0°557',
                  showEdit: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF70B9BE),            minimumSize: const Size(double.infinity, 56),
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
      ),);
  }

  Widget _buildAddressItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool showArrow = false,
    bool showEdit = false,
  }) {
    return Container(
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
              color: Color(0xFF70B9BE),              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, ),      ),
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
            Icon(Icons.edit, color: Color(0xFF70B9BE),)
        ],
      ),
    );
  }
}