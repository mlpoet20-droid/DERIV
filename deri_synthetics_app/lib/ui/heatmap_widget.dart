import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/state_provider.dart';

class HeatmapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StateProvider>(context);

    // Simulate AEZ per timeframe (you can later replace with real AEZ from autonomous loop)
    Map<String, String> aezMap = {
      "1m": provider.currentAEZ, 
      "5m": provider.currentAEZ, 
      "15m": provider.currentAEZ
    };

    // Map AEZ to colors
    Color getColor(String aez) {
      switch (aez) {
        case "green": return Colors.green;
        case "yellow": return Colors.yellow;
        case "red": return Colors.red;
        default: return Colors.grey;
      }
    }

    return Card(
      color: Colors.black87,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("AEZ Multi-Timeframe Heatmap", style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: aezMap.entries.map((e) => Column(
                children: [
                  Text(e.key, style: TextStyle(color: Colors.white)),
                  SizedBox(height: 5),
                  Container(
                    width: 50,
                    height: 50,
                    color: getColor(e.value),
                  ),
                  SizedBox(height: 5),
                  Text(e.value.toUpperCase(), style: TextStyle(color: Colors.white)),
                ],
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}