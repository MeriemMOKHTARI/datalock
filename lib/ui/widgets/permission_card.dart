import 'package:flutter/material.dart';
import '../../config/config.dart';
import 'package:easy_localization/easy_localization.dart';

class PermissionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onAccept;
  final VoidCallback onDeny;

  const PermissionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onAccept,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: Colors.white, 
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: Config.themeData.primaryColor),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Config.themeData.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black87, 
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: onDeny,
                    child:  Text('Non'.tr(),
                        style: TextStyle(color: Colors.black87)), // Update: Changed button text color to black87
                  ),
                  ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Config.themeData.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child:  Text('Oui'.tr(),
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
