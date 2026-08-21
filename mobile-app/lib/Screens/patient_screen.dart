import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../widgets/dox_logo.dart';
import 'doctorlist.dart';

class PatientQueueScreen extends StatelessWidget {
  const PatientQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final booking = appState.booking;
    final doctor = appState.selectedDoctor;
    final queue = appState.queueStatus;

    if (booking == null || doctor == null || queue == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF7F4EF),
        appBar: AppBar(
          title: const DoxLogo(size: DoxLogoSize.compact),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'No active booking found',
                style: TextStyle(fontSize: 16, color: Color(0xFF4C5562)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const DoctorListScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Back to Doctors'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      appBar: AppBar(
        title: const DoxLogo(size: DoxLogoSize.compact),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Color(0xFF303030)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF303030)),
            tooltip: 'Close & Clear Booking',
            onPressed: () {
              appState.clear();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const DoctorListScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: appState.refreshQueue,
        color: const Color(0xFF303030),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            const Text(
              'DOX',
              style: TextStyle(
                letterSpacing: 1.5,
                color: Color(0xFF7D8187),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              doctor.name,
              style: GoogleFonts.outfit(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF303030),
              ),
            ),
            Text(
              doctor.specialization,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),

            // Main Token Card
            Card(
              color: const Color(0xFF303030),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        'YOUR TOKEN',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '#${booking.tokenNumber}',
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 64,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD84D),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          queue.status,
                          style: const TextStyle(
                            color: Color(0xFF303030),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Stats row
            Row(
              children: [
                Expanded(
                  child: _stat(
                    'Now Serving',
                    queue.currentToken == null ? '—' : '#${queue.currentToken}',
                    isPrimary: true,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _stat(
                    'Patients Ahead',
                    '${queue.patientsAhead}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _stat(
              'Estimated Wait',
              '${queue.estimatedWaitMinutes} min',
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Pull down to refresh',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value, {bool isPrimary = false}) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF303030),
                ),
              ),
            ],
          ),
        ),
      );
}
