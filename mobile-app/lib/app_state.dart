import 'package:flutter/foundation.dart';
import 'models.dart';
import 'services/api_service.dart';
import 'services/queue_socket_service.dart';

class AppState extends ChangeNotifier {
  AppState({ApiService? api, QueueSocketService? socket}) : _api = api ?? ApiService(), _socket = socket ?? QueueSocketService();
  final ApiService _api;
  final QueueSocketService _socket;
  List<Clinic> _clinics = [];
  PatientDetails? _patient;
  Doctor? _selectedDoctor;
  TokenBooking? _booking;
  QueueStatus? _queueStatus;
  bool _loading = false;
  String? _error;
  List<Clinic> get clinics => List.unmodifiable(_clinics);
  PatientDetails? get patient => _patient;
  Doctor? get selectedDoctor => _selectedDoctor;
  TokenBooking? get booking => _booking;
  QueueStatus? get queueStatus => _queueStatus;
  bool get loading => _loading;
  String? get error => _error;
  Future<void> loadClinics() async {
    _loading = true; _error = null; notifyListeners();
    try { _clinics = await _api.getClinics(); } on ApiException catch (e) { _error = e.message; } finally { _loading = false; notifyListeners(); }
  }
  void setPatient(PatientDetails patient) { _patient = patient; _error = null; notifyListeners(); }
  void selectDoctor(Doctor doctor) { _selectedDoctor = doctor; notifyListeners(); }
  Future<bool> bookSelectedDoctor() async {
    if (_patient == null || _selectedDoctor == null) return false;
    _loading = true; _error = null; notifyListeners();
    try { _booking = await _api.bookToken(doctorId: _selectedDoctor!.id, patient: _patient!); _queueStatus = _booking!.queue; _watchQueue(); return true; } on ApiException catch (e) { _error = e.message; return false; } finally { _loading = false; notifyListeners(); }
  }
  Future<void> refreshQueue() async {
    if (_booking == null) return;
    try { _queueStatus = await _api.getTokenStatus(_booking!.tokenId); notifyListeners(); } on ApiException catch (e) { _error = e.message; notifyListeners(); }
  }
  void _watchQueue() { _socket.watchDoctor(_selectedDoctor!.id, refreshQueue); }
  void clear() { _socket.dispose(); _patient = null; _selectedDoctor = null; _booking = null; _queueStatus = null; _error = null; notifyListeners(); }
  @override void dispose() { _socket.dispose(); super.dispose(); }
}
