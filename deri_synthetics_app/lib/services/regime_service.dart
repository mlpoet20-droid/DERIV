import '../models/engine_state.dart';

class RegimeService {
  EngineState state;

  RegimeService({required this.state});

  // Classify regime based on recent SP and IV trends
  String classifyRegime(List<double> spHistory, List<double> ivHistory) {
    if (spHistory.isEmpty || ivHistory.isEmpty) return "neutral";

    double spChange = spHistory.last - spHistory.first;
    double ivChange = ivHistory.last - ivHistory.first;

    if (spChange > 0.05 && ivChange > 0.05) return "bullish_high_vol";
    if (spChange > 0.05 && ivChange <= 0.05) return "bullish_low_vol";
    if (spChange < -0.05 && ivChange > 0.05) return "bearish_high_vol";
    if (spChange < -0.05 && ivChange <= 0.05) return "bearish_low_vol";

    return "neutral";
  }

  // Adjust adaptive threshold theta based on regime
  void adjustThetaByRegime(String regime) {
    switch (regime) {
      case "bullish_high_vol":
        state.theta *= 1.05; // slightly stricter threshold
        break;
      case "bullish_low_vol":
        state.theta *= 0.98; // more permissive
        break;
      case "bearish_high_vol":
        state.theta *= 1.08;
        break;
      case "bearish_low_vol":
        state.theta *= 0.99;
        break;
      case "neutral":
      default:
        state.theta = state.theta; // no change
    }
  }

  // Update AEZ dynamically based on regime
  String computeDynamicAEZ() {
    if (state.iv > state.theta * 1.1) return "green";
    if (state.iv >= state.theta * 0.95) return "yellow";
    return "red";
  }

  // Full regime step: classify and adjust
  void step(List<double> spHistory, List<double> ivHistory) {
    String regime = classifyRegime(spHistory, ivHistory);
    adjustThetaByRegime(regime);
    // AEZ can be used by trading panel
    state.ee = computeDynamicAEZ() == "green" ? state.ee * 1.05 : state.ee;
  }
}