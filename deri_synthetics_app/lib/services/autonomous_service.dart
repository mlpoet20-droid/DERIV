import 'dart:async';
import 'broker_service.dart';
import 'engine_service.dart';
import 'regime_service.dart';
import '../models/engine_state.dart';
import 'compounding_service.dart';

class AutonomousService {
  final EngineState state;
  final EngineService engine;
  final RegimeService regimeService;
  final BrokerService broker;
  final double equity;
  Timer? _timer1m;
  Timer? _timer5m;
  Timer? _timer15m;

  AutonomousService({
    required this.state,
    required this.engine,
    required this.regimeService,
    required this.broker,
    required this.equity,
  });

  // Start all loops
  void start() {
    _timer1m = Timer.periodic(Duration(seconds: 5), (_) => tick(60)); // simulate 1min
    _timer5m = Timer.periodic(Duration(seconds: 15), (_) => tick(300)); // simulate 5min
    _timer15m = Timer.periodic(Duration(seconds: 45), (_) => tick(900)); // simulate 15min
  }

  void stop() {
    _timer1m?.cancel();
    _timer5m?.cancel();
    _timer15m?.cancel();
  }

  void tick(int durationSeconds) {
    // Step engine
    engine.step();

    // Update regime and AEZ
    String aez = regimeService.computeDynamicAEZ();

    // Compute order size
    TieredCompounding tiered = TieredCompounding(equity: equity);
    double orderSize = tiered.computeOrderSize(aez);

    // Decide contract type
    String contractType = engine.manifest() ? "CALL" : "PUT";

    // Execute trade on all synthetics
    for (var symbol in ["R_25", "R_50", "R_75", "R_100"]) {
      broker.buy(symbol, orderSize, contractType, durationSeconds);
    }

    // Dynamic S0 & θ adaptation already handled in engine.step()
  }
}