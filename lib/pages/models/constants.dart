import 'package:flutter/material.dart';

class Constants {
  final Color primaryColor = const Color.fromARGB(
    101,
    1,
    75,
    97,
  ); // لون أساسي شبه شفاف
  final Color secondaryColor = const Color.fromARGB(
    255,
    26,
    26,
    26,
  ); // لون ثانوي شبه شفاف
  final Gradient primaryGradient = const LinearGradient(
    colors: [
      Color.fromARGB(31, 163, 222, 230), // شفافية 90
      Color.fromARGB(118, 115, 178, 214), // شفافية 100
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  final Gradient secondaryGradient = const LinearGradient(
    colors: [
      Color.fromARGB(248, 139, 165, 214), // شفافية 80
      Color.fromARGB(239, 94, 179, 228), // شفافية 60
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
