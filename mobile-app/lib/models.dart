class PatientDetails {
  const PatientDetails({required this.name, required this.phone, required this.age, required this.gender});
  final String name;
  final String phone;
  final int age;
  final String gender;
  Map<String, dynamic> toJson() => {'name': name, 'phone': phone, 'age': age, 'gender': gender};
}

class Clinic {
  const Clinic({required this.id, required this.name, required this.address, required this.doctors});
  final int id;
  final String name;
  final String address;
  final List<Doctor> doctors;
  factory Clinic.fromJson(Map<String, dynamic> json) => Clinic(id: _int(json['id']), name: '${json['name'] ?? 'Clinic'}', address: '${json['address'] ?? ''}', doctors: ((json['doctors'] ?? json['doctorProfiles'] ?? []) as List).map((item) => Doctor.fromJson(Map<String, dynamic>.from(item as Map))).toList());
}

class Doctor {
  const Doctor({required this.id, required this.name, required this.specialization, required this.status});
  final int id;
  final String name;
  final String specialization;
  final String status;
  bool get isActive => status == 'ACTIVE';
  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(id: _int(json['id']), name: '${json['name'] ?? 'Doctor'}', specialization: '${json['specialization'] ?? 'General clinic'}', status: '${json['status'] ?? 'ACTIVE'}');
}

class TokenBooking {
  const TokenBooking({required this.tokenId, required this.tokenNumber, required this.status, required this.queue});
  final int tokenId;
  final int tokenNumber;
  final String status;
  final QueueStatus queue;
  factory TokenBooking.fromJson(Map<String, dynamic> json) {
    final token = Map<String, dynamic>.from(json['token'] as Map);
    return TokenBooking(tokenId: _int(token['id']), tokenNumber: _int(token['tokenNumber']), status: '${token['status']}', queue: QueueStatus.fromJson(Map<String, dynamic>.from(json['queue'] as Map), tokenNumber: _int(token['tokenNumber'])));
  }
}

class QueueStatus {
  const QueueStatus({required this.tokenNumber, required this.status, required this.currentToken, required this.patientsAhead, required this.estimatedWaitMinutes});
  final int tokenNumber;
  final String status;
  final int? currentToken;
  final int patientsAhead;
  final int estimatedWaitMinutes;
  factory QueueStatus.fromJson(Map<String, dynamic> json, {int tokenNumber = 0}) => QueueStatus(tokenNumber: _int(json['tokenNumber'], fallback: tokenNumber), status: '${json['status'] ?? 'WAITING'}', currentToken: json['currentToken'] == null ? null : _int(json['currentToken']), patientsAhead: _int(json['patientsAhead']), estimatedWaitMinutes: _int(json['estimatedWaitMinutes']));
}

int _int(dynamic value, {int fallback = 0}) => value is int ? value : int.tryParse('$value') ?? fallback;
