import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class StompService {
  StompClient? _stompClient;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  void connect() {
    _stompClient = StompClient(
      config: StompConfig(
        url: 'wss://io.linkmonitoramento.com.br/roteiro-entrega/v1/ws',
        onConnect: onConnect,
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 200));
          print('connecting...');
        },
        onDisconnect: (frame){
          _isConnected = false; // Atualiza o estado ao desconectar.
        },
        onWebSocketError: (dynamic error) {
          print(error.toString());
          _isConnected = false; // Atualiza o estado ao desconectar.
        },
      ),
    );
    _stompClient?.activate();
  }

  void onConnect(StompFrame frame) {
    _isConnected = true; // Atualiza o estado ao conectar.
    print('Conectado ao web socket');
    // _stompClient?.send(destination: '/salva_posicao', headers: {'content-type': 'plain/text'}, body: 'teste');
  }

  void disconnect() {
    _stompClient?.deactivate();
  }

  void sendMessage(String destination, String message) {
    if (_isConnected) {
      print("Enviando mensagem para $destination");
      _stompClient?.send(destination: destination, headers: {'content-type': 'application/json'}, body: message);
    } else {
      print("Não conectado. Mensagem não enviada para $destination");
      // connect();
    }
  }
}
