/// Exact request body accepted by POST /api/tokens.
class BookTokenPayload {
  const BookTokenPayload({required this.doctorId, required this.patient});

  final int doctorId;
  final Map<String, dynamic> patient;

  Map<String, dynamic> toJson() => {
        'doctorId': doctorId,
        'patient': patient,
      };
}
