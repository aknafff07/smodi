import 'package:flutter/material.dart';
import 'package:smodi/core/constants/colors.dart';

class IoTDeviceSettingsScreen extends StatefulWidget {
  const IoTDeviceSettingsScreen({super.key});

  @override
  State<IoTDeviceSettingsScreen> createState() => _IoTDeviceSettingsScreenState();
}

class _IoTDeviceSettingsScreenState extends State<IoTDeviceSettingsScreen> {
  // Dummy list of IoT devices
  List<Map<String, dynamic>> _devices = [
    {'name': 'FocusLight Pro', 'status': 'Connected', 'isOnline': true},
    {'name': 'WorkSense Camera', 'status': 'Connected', 'isOnline': true},
    {'name': 'Ambient Soundscape', 'status': 'Disconnected', 'isOnline': false},
  ];

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.errorColor : AppColors.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headingText,
      appBar: AppBar(
        backgroundColor: AppColors.headingText,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Manage IoT Devices'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connected Devices:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: _devices.isEmpty
                  ? Center(
                child: Text(
                  'No IoT devices added yet.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  final device = _devices[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    color: Colors.white.withOpacity(0.08),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                    child: ListTile(
                      leading: Icon(
                        device['isOnline'] ? Icons.check_circle_outline : Icons.cancel_outlined,
                        color: device['isOnline'] ? AppColors.successColor : AppColors.errorColor,
                      ),
                      title: Text(
                        device['name'],
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      subtitle: Text(
                        'Status: ${device['status']}',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white54),
                        onPressed: () {
                          _showSnackbar('Settings for ${device['name']} (Coming Soon)');
                        },
                      ),
                      onTap: () {
                        _showSnackbar('Toggling connection for ${device['name']} (Dummy)');
                        setState(() {
                          device['isOnline'] = !device['isOnline'];
                          device['status'] = device['isOnline'] ? 'Connected' : 'Disconnected';
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _showSnackbar('Scanning for new devices... (Coming Soon)');
                  // Simulate adding a new device after a delay
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      setState(() {
                        _devices.add({'name': 'New Device ${_devices.length + 1}', 'status': 'Connected', 'isOnline': true});
                        _showSnackbar('New device found and connected!');
                      });
                    }
                  });
                },
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                label: const Text('Add New Device', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}