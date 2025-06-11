import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';

class SettingsListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing; // Bisa berupa Switch, Text, atau Icon
  final VoidCallback? onTap;
  final Color iconColor;
  final Color textColor;

  const SettingsListTile({
    super.key,
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
    this.iconColor = Colors.white54, // Default icon color
    this.textColor = Colors.white, // Default text color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05), // Sedikit latar belakang transparan
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white30) : null),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}