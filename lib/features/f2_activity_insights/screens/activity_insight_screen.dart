import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';
import 'package:smodi/features/f2_activity_insights/widgets/activity_chart.dart';
import 'package:smodi/features/f2_activity_insights/widgets/activity_log_entry.dart';
// Untuk demo, kita bisa membuat model dummy jika diperlukan,
// atau langsung gunakan Map<String, dynamic> untuk data dummy.

class ActivityInsightsScreen extends StatefulWidget {
  const ActivityInsightsScreen({super.key});

  @override
  State<ActivityInsightsScreen> createState() => _ActivityInsightsScreenState();
}

class _ActivityInsightsScreenState extends State<ActivityInsightsScreen> {
  // Dummy data untuk grafik dan log
  // Nanti ini akan diganti dengan data dari database/Supabase
  String _selectedPeriod = 'Daily'; // Daily, Weekly, Monthly
  DateTime _selectedDate = DateTime.now(); // Untuk filter tanggal/periode

  Map<String, List<double>> _dummyChartData = {
    'Daily': [4, 6, 3, 7, 5, 8, 2], // Jam fokus per hari (misal 7 hari terakhir)
    'Weekly': [25, 30, 20, 35], // Jam fokus per minggu (misal 4 minggu terakhir)
    'Monthly': [100, 120, 90], // Jam fokus per bulan (misal 3 bulan terakhir)
  };

  List<Map<String, String>> _dummyActivityLogs = [
    {
      'time': '10:00 AM - 10:25 AM',
      'description': 'Deep Focus Session on Project X.',
      'tags': 'Work, Coding',
      'image': 'assets/images/placeholder_activity_1.png', // Anda perlu menambahkan gambar dummy
    },
    {
      'time': '11:00 AM - 11:15 AM',
      'description': 'Meeting with Team A.',
      'tags': 'Meeting',
      'image': 'assets/images/placeholder_activity_2.png',
    },
    {
      'time': '02:00 PM - 02:45 PM',
      'description': 'Research for new feature.',
      'tags': 'Research, Learning',
      'image': 'assets/images/placeholder_activity_3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Activity & AI Insights (F2)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add New Tag clicked! (Coming Soon)')),
              );
              // TODO: Navigasi ke layar tambah tag atau tampilkan dialog
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Productivity Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Ringkasan Statistik
            _buildSummaryCard(),
            const SizedBox(height: 30),

            // Filter Periode
            _buildPeriodFilter(),
            const SizedBox(height: 20),

            // Area Grafik
            const Text(
              'Focus Duration Over Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ActivityChart(
              data: _dummyChartData[_selectedPeriod]!,
              period: _selectedPeriod,
            ),
            const SizedBox(height: 30),

            // Log Riwayat Kegiatan
            const Text(
              'Activity Log History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true, // Penting agar ListView tidak mengambil semua ruang
              physics: const NeverScrollableScrollPhysics(), // Agar scroll utama yang bekerja
              itemCount: _dummyActivityLogs.length,
              itemBuilder: (context, index) {
                final log = _dummyActivityLogs[index];
                return ActivityLogEntry(
                  time: log['time']!,
                  description: log['description']!,
                  tags: log['tags']!,
                  imageUrl: log['image'], // Bisa null jika tidak ada gambar
                );
              },
            ),
            const SizedBox(height: 20),

            // Contoh Tombol untuk Menampilkan Cuplikan Kemajuan
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Showing progress snapshots... (Coming Soon)')),
                );
                // TODO: Tampilkan galeri atau daftar cuplikan gambar
              },
              icon: const Icon(Icons.photo_library_outlined, color: Colors.white),
              label: const Text('View Progress Snapshots', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor.withOpacity(0.7),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget untuk Summary Card
  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.2), // Latar belakang transparan
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.5)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Focus Today:',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          Text(
            '3h 45m', // Dummy value
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.accentColor,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Productivity Score:',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          Text(
            '85%', // Dummy value
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Filter Periode (Daily, Weekly, Monthly)
  Widget _buildPeriodFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFilterChip('Daily'),
        _buildFilterChip('Weekly'),
        _buildFilterChip('Monthly'),
        // Tombol untuk memilih tanggal spesifik
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Colors.white),
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2023),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: AppColors.primaryColor, // Warna utama date picker
                      onPrimary: Colors.white,
                      surface: Colors.black, // Warna latar belakang date picker
                      onSurface: Colors.white,
                    ),
                    dialogBackgroundColor: Colors.black, // Background dialog date picker
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null && picked != _selectedDate) {
              setState(() {
                _selectedDate = picked;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data for: ${_selectedDate.toLocal().toString().split(' ')[0]} (Dummy)')),
                );
                // Nanti: muat data grafik dan log berdasarkan tanggal yang dipilih
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildFilterChip(String period) {
    return ChoiceChip(
      label: Text(period),
      selected: _selectedPeriod == period,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedPeriod = period;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Viewing data for: $period')),
            );
            // Nanti: muat data grafik dan log berdasarkan periode yang dipilih
          });
        }
      },
      selectedColor: AppColors.accentColor,
      labelStyle: TextStyle(
        color: _selectedPeriod == period ? AppColors.primaryColor : Colors.white,
      ),
      backgroundColor: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: _selectedPeriod == period ? AppColors.accentColor : Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }
}