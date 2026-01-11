class Trade {
  String symbol;
  double amount;
  String contractType;
  int duration;
  double entryIV;

  Trade({required this.symbol, required this.amount, required this.contractType, required this.duration, required this.entryIV});
}