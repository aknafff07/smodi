import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';

class ActivityLogEntry extends StatelessWidget {
  final String time;
  final String description;
  final String tags;
  final String? imageUrl; // Opsional, untuk cuplikan gambar

  const ActivityLogEntry({
    super.key,
    required this.time,
    required this.description,
    required this.tags,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white.withOpacity(0.08), // Latar belakang kartu transparan
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Container(
                width: 70,
                height: 70,
                margin: const EdgeInsets.only(right: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(imageUrl!), // Pastikan gambar ada di assets
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: imageUrl!.isEmpty
                    ? const Icon(Icons.image, color: Colors.white54, size: 40)
                    : null, // Placeholder jika gambar kosong
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0, // Jarak antar tag
                    runSpacing: 4.0, // Jarak antar baris tag
                    children: tags.split(',').map((tag) {
                      return Chip(
                        label: Text(tag.trim()),
                        backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                        labelStyle: const TextStyle(color: AppColors.primaryColor, fontSize: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: AppColors.primaryColor.withOpacity(0.5)),
                        ),
                      );
                    }).toList(),
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