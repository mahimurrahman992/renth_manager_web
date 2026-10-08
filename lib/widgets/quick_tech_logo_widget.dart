
import 'dart:developer';

import '../consts/consts.dart';

Widget buildLogo() {
  try {
    return Image.asset(
      "assets/images/logo.png",
      scale: 5,
      errorBuilder: (context, error, stackTrace) {
        log('Logo loading error: $error');
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(40),
          ),
          child: const Icon(Icons.business, size: 40, color: Colors.grey),
        );
      },
    );
  } catch (e) {
    log('Logo widgets error: $e');
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(40),
      ),
      child: const Icon(Icons.business, size: 40, color: Colors.grey),
    );
  }
}