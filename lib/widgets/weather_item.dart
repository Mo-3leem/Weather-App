import 'package:flutter/material.dart';

class weatherItem extends StatelessWidget {
  const weatherItem({
    super.key,
    required this.value,
    required this.text,
    required this.unit,
    required this.imageUrl,
    this.white = false,
  });

  final int value;
  final bool white;
  final String text;
  final String unit;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(color: white ? Color(0xffE0E8FB) : Colors.black54),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10.0),
          height: 60,
          width: 60,
          decoration: const BoxDecoration(
            // color: Color.fromARGB(255, 229, 224, 251),
            color: Color.fromARGB(57, 32, 32, 32),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Image.asset(imageUrl),
        ),
        const SizedBox(height: 8),
        Text(
          value.toString() + unit,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: (white ? Color(0xffE0E8FB) : Colors.black54),
          ),
        ),
      ],
    );
  }
}
