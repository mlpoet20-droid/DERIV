class EngineState {
  double phi = 0;
  double sf = 0;
  double iv = 0;
  double s0 = 0;
  double theta = 0.5;
  double sp = Settings.spInitial;
  double ee = Settings.eeInitial;
  double smz = 0;
  List<double> layeredTrades = [];

  void updateS0(double iv, double alpha) {
    s0 += alpha * (iv - theta).clamp(0, double.infinity);
  }

  void updateTheta(double k) {
    theta += k * s0;
  }
}