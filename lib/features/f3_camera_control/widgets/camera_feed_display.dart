import 'package:flutter/material.dart';

class CameraFeedDisplay extends StatelessWidget {
  final String imageUrl;

  const CameraFeedDisplay({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Image.asset(
        imageUrl,
        key: ValueKey<String>(imageUrl), // Key unik untuk animasi switcher
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}