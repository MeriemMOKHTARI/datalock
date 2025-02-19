import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool pushEnabled = false;
  bool smsEnabled = false;
  bool emailEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationOption(
            title: 'Notification Push',
            subtitle: "Recevez les dernières offres et promotions via l'application",
            value: pushEnabled,
            onChanged: (value) {
              setState(() {
                pushEnabled = value;
              });
            },
          ),
          const SizedBox(height: 24),
          _buildNotificationOption(
            title: 'Notifications par SMS',
            subtitle: 'Recevez les dernières offres et promotions via SMS',
            value: smsEnabled,
            onChanged: (value) {
              setState(() {
                smsEnabled = value;
              });
            },
          ),
          const SizedBox(height: 24),
          _buildNotificationOption(
            title: 'Notification par email',
            subtitle: 'Recevez les dernières offres et promotions via email',
            value: emailEnabled,
            onChanged: (value) {
              setState(() {
                emailEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationOption({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Transform.scale(
          scale: 0.8,
          alignment: Alignment.centerLeft,
          child: CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        ),
      ],
    );
  }
}