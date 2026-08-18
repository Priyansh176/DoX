import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:waitless/Screens/auth_screen.dart';
import 'package:waitless/app_state.dart';

class PatientQueueScreen extends StatelessWidget {
  const PatientQueueScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final booking = appState.booking;
    final doctor = appState.selectedDoctor;
    final queue = appState.queueStatus;
    if (booking == null || doctor == null || queue == null) return const Scaffold(body: Center(child: Text('Booking not found')));
    return Scaffold(appBar: AppBar(title: const Text('Your token'), automaticallyImplyLeading: false, actions: [IconButton(icon: const Icon(Icons.close), onPressed: () { appState.clear(); Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const AuthScreen()), (route) => false); })]), body: RefreshIndicator(onRefresh: appState.refreshQueue, child: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('BOOKING CONFIRMED', style: TextStyle(letterSpacing: 1.5, color: Color(0xFF7D8187), fontSize: 12)), const SizedBox(height: 8), Text(doctor.name, style: GoogleFonts.outfit(fontSize: 30, fontWeight: FontWeight.w700)), Text(doctor.specialization, style: const TextStyle(color: Color(0xFF6B7280))), const SizedBox(height: 24),
      Card(color: const Color(0xFF303030), child: Padding(padding: const EdgeInsets.all(28), child: Center(child: Column(children: [const Text('YOUR TOKEN', style: TextStyle(color: Colors.white70, letterSpacing: 1.2)), Text('#${booking.tokenNumber}', style: GoogleFonts.outfit(color: Colors.white, fontSize: 62, fontWeight: FontWeight.w700)), const SizedBox(height: 8), Text(queue.status, style: const TextStyle(color: Color(0xFFFFD84D), fontWeight: FontWeight.bold))]))),
      const SizedBox(height: 18), Row(children: [Expanded(child: _stat('Now serving', queue.currentToken == null ? '—' : '#${queue.currentToken}')), const SizedBox(width: 14), Expanded(child: _stat('Patients ahead', '${queue.patientsAhead}'))]), const SizedBox(height: 14), _stat('Estimated wait', '${queue.estimatedWaitMinutes} min'), const SizedBox(height: 24), const Text('Live queue tracking is on. Pull down to refresh.', style: TextStyle(color: Color(0xFF6B7280))),
    ])));
  }

  Widget _stat(String label, String value) => Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xFF6B7280))), const SizedBox(height: 8), Text(value, style: GoogleFonts.outfit(fontSize: 25, fontWeight: FontWeight.w700))])));
}
