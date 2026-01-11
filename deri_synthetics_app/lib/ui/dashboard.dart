import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/state_provider.dart';
import 'charts.dart';
import 'trade_panel.dart';
import 'alerts.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StateProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Deriv Synthetics Trading")),
      body: RefreshIndicator(
        onRefresh: () async {
          provider.tick(); // run one simulation tick
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              ChartsWidget(
                state: provider.state,
                ivData: provider.ivHistory,
              ),
              SizedBox(height: 10),
              TradePanelWidget(
                equity: 1000, // can be dynamic
                aezZone: provider.currentAEZ,
              ),
              SizedBox(height: 10),
              AlertsWidget(
                alerts: [
                  provider.manifest ? "Manifest Occurred!" : "No Manifest",
                  "Current AEZ: ${provider.currentAEZ}",
                  "Theta: ${provider.state.theta.toStringAsFixed(3)}",
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          provider.tick(); // manual tick for demo
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
import 'heatmap_widget.dart';

Column(
  children = [
    ChartsWidget(
      state: provider.state,
      ivData: provider.ivHistory,
    ),
    SizedBox(height: 10),
    HeatmapWidget(), // Added heatmap here
    SizedBox(height: 10),
    TradePanelWidget(
      equity: 1000,
      aezZone: provider.currentAEZ,
    ),
    SizedBox(height: 10),
    AlertsWidget(
      alerts: [
        provider.manifest ? "Manifest Occurred!" : "No Manifest",
        "Current AEZ: ${provider.currentAEZ}",
        "Theta: ${provider.state.theta.toStringAsFixed(3)}",
      ],
    ),
  ],
)
import 'heatmap_advanced_widget.dart';

Column(
  children = [
    ChartsWidget(
      state: provider.state,
      ivData: provider.ivHistory,
    ),
    SizedBox(height: 10),
    HeatmapAdvancedWidget(), // Replaces old static heatmap
    SizedBox(height: 10),
    TradePanelWidget(
      equity: 1000,
      aezZone: provider.currentAEZ,
    ),
    SizedBox(height: 10),
    AlertsWidget(
      alerts: [
        provider.manifest ? "Manifest Occurred!" : "No Manifest",
        "Current AEZ: ${provider.currentAEZ}",
        "Theta: ${provider.state.theta.toStringAsFixed(3)}",
      ],
    ),
  ],
)import 'heatmap_advanced_widget.dart';

Column(
  children = [
    ChartsWidget(
      state: provider.state,
      ivData: provider.ivHistory,
    ),
    SizedBox(height: 10),
    HeatmapAdvancedWidget(), // Replaces old static heatmap
    SizedBox(height: 10),
    TradePanelWidget(
      equity: 1000,
      aezZone: provider.currentAEZ,
    ),
    SizedBox(height: 10),
    AlertsWidget(
      alerts: [
        provider.manifest ? "Manifest Occurred!" : "No Manifest",
        "Current AEZ: ${provider.currentAEZ}",
        "Theta: ${provider.state.theta.toStringAsFixed(3)}",
      ],
    ),
  ],
)
import 'heatmap_pro_widget.dart';

Column(
  children = [
    ChartsWidget(
      state: provider.state,
      ivData: provider.ivHistory,
    ),
    SizedBox(height: 10),
    HeatmapProWidget(), // New interactive pro heatmap
    SizedBox(height: 10),
    TradePanelWidget(
      equity: 1000,
      aezZone: provider.currentAEZ,
    ),
    SizedBox(height: 10),
    AlertsWidget(
      alerts: [
        provider.manifest ? "Manifest Occurred!" : "No Manifest",
        "Current AEZ: ${provider.currentAEZ}",
        "Theta: ${provider.state.theta.toStringAsFixed(3)}",
      ],
    ),
  ],
)