import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class BrokerService {
  final String token;
  late IOWebSocketChannel channel;

  BrokerService({required this.token});

  void connect() {
    channel = IOWebSocketChannel.connect('wss://ws.binaryws.com/websockets/v3?app_id=1089');
    authenticate();
  }

  void authenticate() {
    channel.sink.add(jsonEncode({'authorize': token}));
  }

  void subscribeMultiple(List<String> symbols) {
    for (var s in symbols) subscribeTicks(s);
  }

  void subscribeTicks(String symbol) {
    channel.sink.add(jsonEncode({'ticks': symbol, 'subscribe': 1}));
  }

  void buy(String symbol, double amount, String contractType, int duration) {
    channel.sink.add(jsonEncode({'buy':1,'symbol':symbol,'amount':amount,'contract_type':contractType,'duration':duration}));
  }
}
class BrokerService {
  final String token;
  late IOWebSocketChannel channel;

  BrokerService({required this.token});

  void connect() {
    channel = IOWebSocketChannel.connect(
        'wss://ws.binaryws.com/websockets/v3?app_id=1089');
    authenticate();
  }

  void authenticate() {
    channel.sink.add(jsonEncode({'authorize': token}));
  }

  void subscribeMultiple(List<String> symbols) {
    for (var s in symbols) {
      subscribeTicks(s);
    }
  }

  void subscribeTicks(String symbol) {
    channel.sink.add(jsonEncode({'ticks': symbol, 'subscribe': 1}));
  }

  void buy(String symbol, double amount, String contractType, int duration) {
    channel.sink.add(jsonEncode({
      'buy': 1,
      'symbol': symbol,
      'amount': amount,
      'contract_type': contractType,
      'duration': duration
    }));
  }
}