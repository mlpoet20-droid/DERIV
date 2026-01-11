import 'dart:math';
import '../config/settings.dart';

class RiskManager {
  double maxDD;
  double equityPeak = 0;
  double currentDD = 0;

  RiskManager({this.maxDD = Settings.maxDrawdown});

  bool update(double equity) {
    equityPeak = max(equityPeak, equity);
    currentDD = (equityPeak - equity) / equityPeak;
    return currentDD >= maxDD;
  }
}