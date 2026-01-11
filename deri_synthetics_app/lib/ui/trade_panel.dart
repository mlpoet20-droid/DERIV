import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/state_provider.dart';
import '../services/compounding_service.dart';

class TradePanelWidget extends StatelessWidget {
  final double equity;
  final String aezZone;

  TradePanelWidget({required this.equity, required this.aezZone});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StateProvider>(context);
    TieredCompounding tiered = TieredCompounding(equity: equity);
    double orderSize = tiered.computeOrderSize(provider.currentAEZ);

    return Card(
      color: Colors.black87,
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Layered Trades - AEZ: ${provider.currentAEZ}", style: TextStyle(color: Colors.white)),
            SizedBox(height: 10),
            Text("Order Size: \$${orderSize.toStringAsFixed(2)}", style: TextStyle(color: Colors.greenAccent)),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add real buy logic here with broker service
                  },
                  child: Text("Buy"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Add real sell logic here with broker service
                  },
                  child: Text("Sell"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}