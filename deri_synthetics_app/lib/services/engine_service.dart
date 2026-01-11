import 'dart:math';
import '../models/cmp.dart';
import '../models/engine_state.dart';
import '../config/settings.dart';

class EngineService {
  EngineState state;
  List<CMP> cmps;

  EngineService({required this.state, required this.cmps});

  double computePhi() {
    state.phi = cmps.fold(0, (sum, cmp) => sum + cmp.weight * cmp.mpl);
    return state.phi;
  }

  double computeSF() {
    double mplPos = cmps.where((c) => c.mpl > 0).fold(0, (s, c) => s + c.mpl);
    double mplNeg = cmps.where((c) => c.mpl < 0).fold(0, (s, c) => s + c.mpl);
    state.sf = Settings.beta * (mplPos - mplNeg).abs() / max(state.s0.abs(), 1e-6);
    return state.sf;
  }

  double computeIV() {
    state.iv = computePhi() * computeSF();
    return state.iv;
  }

  bool manifest() => state.iv >= state.theta;

  void step() {
    computeIV();
    state.updateS0(state.iv, Settings.alpha);
    state.updateTheta(Settings.k);

    if (manifest()) {
      state.layeredTrades.add(state.iv);
      if (state.layeredTrades.length > Settings.maxLayers)
        state.layeredTrades.removeAt(0);
    }
  }
}