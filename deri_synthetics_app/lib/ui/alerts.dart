import 'package:flutter/material.dart';

class AlertsWidget extends StatelessWidget {
  final List<String> alerts;

  AlertsWidget({this.alerts = const ["SP Drop Detected", "AEZ Spike", "θ Threshold Breach"]});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[900],
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Alerts", style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 10),
            ...alerts.map((a) => Text(a, style: TextStyle(color: Colors.white))).toList(),
          ],
        ),
      ),
    );
  }
}