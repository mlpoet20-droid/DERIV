import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/state_provider.dart';
import '../models/engine_state.dart';
import '../services/broker_service.dart';

class HeatmapProWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StateProvider>(context);

    // Define symbols and timeframes
    final symbols = ["R_25", "R_50", "R_75", "R_100"];
    final timeframes = ["1m", "5m", "15m"];

    // Simulated AEZ history per symbol/timeframe
    Map<String, Map<String, List<String>>> aezHistory = {
      for (var sym in symbols)
        sym: {
          for (var tf in timeframes)
            tf: List.generate(provider.ivHistory.length, (_) => provider.currentAEZ)
        }
    };

    // Map AEZ to color
    Color aezToColor(String aez) {
      switch (aez) {
        case "green":
          return Colors.green;
        case "yellow":
          return Colors.yellow;
        case "red":
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    // Simulated open trades per symbol
    Map<String, Map<String, List<int>>> openTrades = {
      for (var sym in symbols)
        sym: {
          for (var tf in timeframes)
            tf: List.generate(aezHistory[sym]![tf]!.length, (i) => i % 5 == 0 ? 1 : 0) // marker every 5 ticks
        }
    };

    // On-click tooltip
    void onZoneClick(String symbol, String timeframe, int index) {
      final ee = provider.state.ee.toStringAsFixed(3);
      final iv = provider.state.iv.toStringAsFixed(3);
      final smz = provider.state.smz.toStringAsFixed(3);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("AEZ Detail"),
          content: Text(
              "Symbol: $symbol\nTimeframe: $timeframe\nIndex: $index\nAEZ: ${aezHistory[symbol]![timeframe]![index].toUpperCase()}\nEE: $ee\nIV: $iv\nSMZ: $smz"),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Example: trigger manual trade
                BrokerService(token: "YOUR_TOKEN").buy(symbol, 10, "CALL", 60);
                Navigator.pop(context);
              },
              child: Text("Trigger Trade"),
            ),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Close")),
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
              "AEZ Pro Heatmap (Multi-Symbol / Multi-Timeframe)",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 10),
            Column(
              children: symbols.map((sym) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sym, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 6),
                    Column(
                      children: timeframes.map((tf) {
                        List<String> history = aezHistory[sym]![tf]!;
                        List<int> trades = openTrades[sym]![tf]!;

                        return GestureDetector(
                          onTapDown: (details) {
                            // Calculate nearest index based on touch
                            RenderBox box = context.findRenderObject() as RenderBox;
                            double localX = details.localPosition.dx;
                            int idx = ((localX / box.size.width) * history.length).clamp(0, history.length - 1).toInt();
                            onZoneClick(sym, tf, idx);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Stack(
                              children: [
                                Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: history.map(aezToColor).toList(),
                                      stops: List.generate(history.length, (i) => i / history.length),
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                // Overlay trade markers
                                Positioned.fill(
                                  child: Row(
                                    children: List.generate(history.length, (i) {
                                      return Expanded(
                                        child: trades[i] == 1
                                            ? Icon(Icons.circle, size: 8, color: Colors.white)
                                            : SizedBox.shrink(),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 12),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}