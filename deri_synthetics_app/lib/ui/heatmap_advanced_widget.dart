import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/state_provider.dart';
import '../services/broker_service.dart';

class HeatmapAdvancedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StateProvider>(context);

    // Simulated multi-timeframe AEZ history
    // In practice, fill from StateProvider's historical AEZ per timeframe
    Map<String, List<String>> aezHistory = {
      "1m": List.generate(provider.ivHistory.length, (_) => provider.currentAEZ),
      "5m": List.generate(provider.ivHistory.length, (_) => provider.currentAEZ),
      "15m": List.generate(provider.ivHistory.length, (_) => provider.currentAEZ),
    };

    // Map AEZ to gradient colors
    Color aezToColor(String aez) {
      switch (aez) {
        case "green": return Colors.green;
        case "yellow": return Colors.yellow;
        case "red": return Colors.red;
        default: return Colors.grey;
      }
    }

    // For clickable zones
    void onZoneClick(String timeframe) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("AEZ Zone Clicked"),
          content: Text(
              "Timeframe: $timeframe\nCurrent AEZ: ${provider.currentAEZ}\nTheta: ${provider.state.theta.toStringAsFixed(3)}"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  // Manual S0 adjustment
                  provider.manualS0Adjust(0.01);
                  Navigator.pop(context);
                },
                child: Text("Adjust Threshold +0.01")),
            ElevatedButton(
                onPressed: () {
                  // Example broker buy trigger (pseudo)
                  BrokerService(token: "YOUR_TOKEN")
                      .buy("R_75", 10, "CALL", 60);
                  Navigator.pop(context);
                },
                child: Text("Trigger Trade")),
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close")),
          ],
        ),
      );
    }

    return Card(
      color: Colors.black87,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              "AEZ Multi-Timeframe Advanced Heatmap",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            ...aezHistory.entries.map((entry) {
              String timeframe = entry.key;
              List<String> history = entry.value;
              return GestureDetector(
                onTap: () => onZoneClick(timeframe),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      Text("$timeframe ", style: TextStyle(color: Colors.white)),
                      Expanded(
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: history.map(aezToColor).toList(),
                              stops: List.generate(history.length,
                                  (i) => i / history.length),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(history.last.toUpperCase(),
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}