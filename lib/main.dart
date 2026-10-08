import 'package:flutter/material.dart';
import 'pages/distribution/distribution_page.dart';

void main() {
  runApp(const WelfareApp());
}

class WelfareApp extends StatelessWidget {
  const WelfareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welfare System',
      home: const DistributionPage(),
    );
  }
}