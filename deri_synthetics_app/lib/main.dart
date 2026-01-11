import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/dashboard.dart';
import 'providers/state_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => StateProvider(),
      child: DerivApp(),
    ),
  );
}

class DerivApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deriv Synthetics Trading',
      theme: ThemeData.dark(),
      home: DashboardPage(),
    );
  }
}