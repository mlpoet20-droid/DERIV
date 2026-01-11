import '../models/engine_state.dart';
import 'dart:math';

class AEPredictor {
  EngineState state;

  AEPredictor({required this.state});

  double predictIV(List<double> historicalIV) {
    int n = min(historicalIV.length, 10);
    double weightedSum = 0;
    double totalWeight = 0;
    for (int i=0;i<n;i++){
      double weight=(n-i).toDouble();
      weightedSum += historicalIV[historicalIV.length-1-i]*weight;
      totalWeight += weight;
    }
    return weightedSum/totalWeight;
  }

  double predictEE() {
    return state.sp * state.iv;
  }

  String computeAEZ(double ivPred) {
    if(ivPred>state.theta*1.05) return "green";
    if(ivPred>=state.theta*0.95) return "yellow";
    return "red";
  }
}