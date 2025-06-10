import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';

class ActivityChart extends StatelessWidget {
  final List<double> data; // Contoh: [4, 6, 3, 7, 5, 8, 2]
  final String period; // Daily, Weekly, Monthly

  const ActivityChart({
    super.key,
    required this.data,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    // Label sumbu X
    List<String> getLabels() {
      switch (period) {
        case 'Daily':
          return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        case 'Weekly':
          return List.generate(data.length, (index) => 'Week ${index + 1}');
        case 'Monthly':
          return List.generate(data.length, (index) => 'Month ${index + 1}');
        default:
          return [];
      }
    }

    final labels = getLabels();
    final maxDataValue = data.reduce((a, b) => a > b ? a : b); // Nilai tertinggi untuk skala

    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end, // Bar mulai dari bawah
              children: data.asMap().entries.map((entry) {
                int index = entry.key;
                double value = entry.value;
                double barHeightRatio = (value / maxDataValue) * 0.8; // Skala bar
                if (maxDataValue == 0) barHeightRatio = 0; // Hindari division by zero

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      value.toStringAsFixed(0), // Tampilkan nilai di atas bar
                      style: const TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 20, // Lebar bar
                      height: 120 * barHeightRatio, // Tinggi bar
                      decoration: BoxDecoration(
                        color: AppColors.accentColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.white.withOpacity(0.3)), // Sumbu X
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: labels
                .map((label) => Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}