import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../models.dart';
import '../widgets/dox_logo.dart';
import 'auth_screen.dart';
import 'patient_screen.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<AppState>().loadClinics();
    });
  }

  Future<void> _handleBook(Doctor doctor) async {
    final appState = context.read<AppState>();
    appState.selectDoctor(doctor);

    // If patient info is missing, prompt user to enter details
    if (appState.patient == null) {
      final completed = await AuthScreen.showBookingSheet(context);
      if (completed != true || !mounted) return;
    }

    final booked = await appState.bookSelectedDoctor();
    if (booked && mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const PatientQueueScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final doctors = appState.clinics
        .expand((clinic) => clinic.doctors.map((doctor) => (clinic: clinic, doctor: doctor)))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      appBar: AppBar(
        title: const DoxLogo(size: DoxLogoSize.compact),
        actions: [
          if (appState.booking != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PatientQueueScreen()),
                  );
                },
                icon: const Icon(Icons.confirmation_number_outlined, size: 18, color: Color(0xFF303030)),
                label: Text(
                  '#${appState.booking!.tokenNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF303030)),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD84D),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFF303030)),
            tooltip: 'Patient Details',
            onPressed: () => AuthScreen.showBookingSheet(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: appState.loadClinics,
        color: const Color(0xFF303030),
        child: appState.loading && doctors.isEmpty
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF303030)))
            : appState.error != null && doctors.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF1F2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFFECDD3)),
                            ),
                            child: Text(
                              appState.error!,
                              style: const TextStyle(color: Color(0xFF9F1239)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: appState.loadClinics,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView(
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
                        'Available Doctors',
                        style: GoogleFonts.outfit(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF303030),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Active Token Quick Banner
                      if (appState.booking != null) ...[
                        Card(
                          color: const Color(0xFF303030),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(22),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const PatientQueueScreen()),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(18),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFD84D),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '#${appState.booking!.tokenNumber}',
                                      style: GoogleFonts.outfit(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF303030),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'ACTIVE TOKEN',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 11,
                                            letterSpacing: 1.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          appState.selectedDoctor?.name ?? 'Doctor Queue',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      if (appState.error != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFECDD3)),
                          ),
                          child: Text(
                            appState.error!,
                            style: const TextStyle(color: Color(0xFF9F1239)),
                          ),
                        ),
                      ],

                      if (doctors.isEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: Center(
                              child: Text(
                                'No doctors are currently available.',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          ),
                        ),

                      ...doctors.map((item) {
                        final clinic = item.clinic;
                        final doctor = item.doctor;
                        final isActive = doctor.isActive;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 14),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            doctor.name,
                                            style: GoogleFonts.outfit(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF303030),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${clinic.name} · ${doctor.specialization}',
                                            style: const TextStyle(
                                              color: Color(0xFF6B7280),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: isActive ? const Color(0xFFECFDF3) : const Color(0xFFFFF1F2),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isActive ? const Color(0xFF86EFAC) : const Color(0xFFFECDD3),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 7,
                                            height: 7,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isActive ? const Color(0xFF166534) : const Color(0xFF9F1239),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            isActive ? 'Active' : 'Inactive',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: isActive ? const Color(0xFF166534) : const Color(0xFF9F1239),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: isActive
                                        ? () => _handleBook(doctor)
                                        : null,
                                    child: appState.loading && appState.selectedDoctor?.id == doctor.id
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Color(0xFF303030),
                                            ),
                                          )
                                        : Text(
                                            isActive ? 'Book Token' : 'Unavailable',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isActive ? const Color(0xFF303030) : Colors.grey,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
      ),
    );
  }
}
