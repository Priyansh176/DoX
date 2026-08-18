import 'package:flutter_test/flutter_test.dart';
import 'package:waitless/api_payloads.dart';

void main() {
  test('booking payload contains only the backend contract fields', () {
    const payload = BookTokenPayload(doctorId: 1, patient: {'name': 'Asha', 'phone': '9999999900', 'age': 30, 'gender': 'Female'});
    expect(payload.toJson(), {'doctorId': 1, 'patient': {'name': 'Asha', 'phone': '9999999900', 'age': 30, 'gender': 'Female'}});
  });
}
