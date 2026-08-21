import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_payloads.dart';
import '../models.dart';

class ApiException implements Exception { const ApiException(this.message); final String message; @override String toString() => message; }
class ApiService {
  ApiService({http.Client? client, String? baseUrl}) : _client = client ?? http.Client(), baseUrl = baseUrl ?? const String.fromEnvironment('API_URL', defaultValue: 'http://172.17.54.228:5000');
  final http.Client _client;
  final String baseUrl;
  Future<List<Clinic>> getClinics() async { final data = await _request('GET', '/api/clinics'); return ((data['clinics'] ?? []) as List).map((item) => Clinic.fromJson(Map<String, dynamic>.from(item as Map))).toList(); }
  Future<TokenBooking> bookToken({required int doctorId, required PatientDetails patient}) async => TokenBooking.fromJson(await _request('POST', '/api/tokens', body: BookTokenPayload(doctorId: doctorId, patient: patient.toJson()).toJson()));
  Future<QueueStatus> getTokenStatus(int tokenId) async => QueueStatus.fromJson(await _request('GET', '/api/tokens/$tokenId'));
  Future<Map<String, dynamic>> _request(String method, String path, {Map<String, dynamic>? body}) async {
    try { final response = await _client.send(http.Request(method, Uri.parse('$baseUrl$path'))..headers['Content-Type'] = 'application/json'..body = body == null ? '' : jsonEncode(body)); final decoded = jsonDecode(await response.stream.bytesToString()) as Map<String, dynamic>; if (response.statusCode < 200 || response.statusCode >= 300) throw ApiException('${decoded['message'] ?? 'Request failed'}'); return Map<String, dynamic>.from(decoded['data'] as Map? ?? decoded); } on ApiException { rethrow; } catch (_) { throw const ApiException('Could not reach the clinic. Please check your connection and try again.'); }
  }
}
