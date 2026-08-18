import 'package:socket_io_client/socket_io_client.dart' as io;
class QueueSocketService {
  QueueSocketService({String? baseUrl}) : baseUrl = baseUrl ?? const String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:5000');
  final String baseUrl;
  io.Socket? _socket;
  void watchDoctor(int doctorId, void Function() onUpdate) { dispose(); _socket = io.io(baseUrl, <String, dynamic>{'transports': ['websocket'], 'autoConnect': false})..onConnect((_) => _socket!.emit('join-doctor-room', doctorId))..on('queue-updated', (_) => onUpdate())..on('doctor-status-changed', (_) => onUpdate())..connect(); }
  void dispose() { _socket?.dispose(); _socket = null; }
}
