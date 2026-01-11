import 'package:flutter/material.dart';
import '../models/engine_state.dart';
import '../services/engine_service.dart';
import '../services/regime_service.dart';

class StateProvider extends ChangeNotifier {
  EngineState state = EngineState();
  late EngineService engine;
  late RegimeService regimeService;

  List<double> spHistory = [];
  List<double> ivHistory = [];

  StateProvider() {
    engine = EngineService(state: state, cmps: []);
    regimeService = RegimeService(state: state);
  }

  // Update CMPs
  void updateCMPS(List<double> mplValues, List<double> weights) {
    engine.cmps = List.generate(mplValues.length, (i) => CMP(mpl: mplValues[i], weight: weights[i]));
  }

  // Single simulation tick
  void tick() {
    engine.step();
    spHistory.add(state.sp);
    ivHistory.add(state.iv);

    // Maintain history length
    if (spHistory.length > 50) spHistory.removeAt(0);
    if (ivHistory.length > 50) ivHistory.removeAt(0);

    // Regime adjustment
    regimeService.step(spHistory, ivHistory);

    // Notify UI listeners
    notifyListeners();
  }

  // Get current AEZ
  String get currentAEZ => regimeService.computeDynamicAEZ();

  // Helper: check if manifest occurred
  bool get manifest => engine.manifest();

  // Manual S0 adjustment (optional)
  void manualS0Adjust(double delta) {
    state.s0 += delta;
    notifyListeners();
  }
}
import 'autonomous_service.dart';
import 'broker_service.dart';

// Add inside StateProvider
AutonomousService? autonomous;

void startAutonomous(String token, double equity) {
  BrokerService broker = BrokerService(token: token);
  broker.connect();

  autonomous = AutonomousService(
    state: state,
    engine: engine,
    regimeService: regimeService,
    broker: broker,
    equity: equity,
  );
  autonomous?.start();
}

void stopAutonomous() {
  autonomous?.stop();
  autonomous = null;
}import 'autonomous_service.dart';
import 'broker_service.dart';

// Add inside StateProvider
AutonomousService? autonomous;

void startAutonomous(String token, double equity) {
  BrokerService broker = BrokerService(token: token);
  broker.connect();

  autonomous = AutonomousService(
    state: state,
    engine: engine,
    regimeService: regimeService,
    broker: broker,
    equity: equity,
  );
  autonomous?.start();
}

void stopAutonomous() {
  autonomous?.stop();
  autonomous = null;
}