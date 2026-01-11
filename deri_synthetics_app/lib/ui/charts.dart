import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/ae_predictor.dart';
import '../models/engine_state.dart';

class ChartsWidget extends StatelessWidget {
  final EngineState state;
  final List<double> ivData;

  ChartsWidget({required this.state, this.ivData = const []});

  @override
  Widget build(BuildContext context) {
    AEPredictor predictor = AEPredictor(state: state);
    double ivPred = predictor.predictIV(ivData);
    String aezZone = predictor.computeAEZ(ivPred);

    Color aezColor;
    switch (aezZone) {
      case "green":
        aezColor = Colors.green.withOpacity(0.3);
        break;
      case "yellow":
        aezColor = Colors.yellow.withOpacity(0.3);
        break;
      default:
        aezColor = Colors.red.withOpacity(0.3);
    }

    return Container(
      height: 200,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: aezColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text("Predictive IV: ${ivPred.toStringAsFixed(3)} - AEZ: $aezZone"),
          // Chart plotting IV data
          Expanded(
            child: LineChart(LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: ivData
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value))
                      .toList(),
                  isCurved: true,
                  colors: [Colors.orange],
                  barWidth: 3,
                  dotData: FlDotData(show: false),
                )
              ],
            )),
          ),
        ],
      ),
    );
  }
}