class TieredCompounding {
  double equity;
  double survivalPct = 0.5;
  double growthPct = 0.3;
  double aggressivePct = 0.2;

  TieredCompounding({required this.equity});

  Map<String,double> allocate() => {
    "survival": equity*survivalPct,
    "growth": equity*growthPct,
    "aggressive": equity*aggressivePct
  };

  double computeOrderSize(String aezZone){
    var tiers=allocate();
    switch(aezZone){
      case "green": return tiers["aggressive"]!;
      case "yellow": return tiers["growth"]!;
      default: return tiers["survival"]!;
    }
  }
}