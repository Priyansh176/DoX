import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:waitless/Screens/auth_screen.dart';
import 'package:waitless/Screens/patient_screen.dart';
import 'package:waitless/app_state.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});
  @override State<DoctorListScreen> createState() => _DoctorListScreenState();
}
class _DoctorListScreenState extends State<DoctorListScreen> {
  @override void initState() { super.initState(); Future.microtask(() => context.read<AppState>().loadClinics()); }
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final doctors = appState.clinics.expand((clinic) => clinic.doctors.map((doctor) => (clinic: clinic, doctor: doctor))).toList();
    return Scaffold(appBar: AppBar(title: const Text('Choose your doctor'), actions: [IconButton(icon: const Icon(Icons.close), onPressed: () { appState.clear(); Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const AuthScreen()), (route) => false); })]), body: Padding(padding: const EdgeInsets.all(20), child: appState.loading ? const Center(child: CircularProgressIndicator()) : appState.error != null ? Center(child: Text(appState.error!)) : ListView(children: [const Text('Clinic Queue', style: TextStyle(letterSpacing: 1.5, color: Color(0xFF7D8187), fontSize: 12)), const SizedBox(height: 8), Text('Available doctors', style: GoogleFonts.outfit(fontSize: 30, fontWeight: FontWeight.w700)), const SizedBox(height: 20), if (doctors.isEmpty) const Card(child: Padding(padding: EdgeInsets.all(20), child: Text('No doctors are currently available.'))), ...List.generate(doctors.length, (index) {
      final clinic = doctors[index].clinic;
      final doctor = doctors[index].doctor;
      return Card(margin: const EdgeInsets.only(bottom: 14), child: ListTile(contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18), title: Text(doctor.name, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700)), subtitle: Text('${clinic.name} · ${doctor.specialization}'), trailing: FilledButton(onPressed: doctor.isActive ? () async { appState.selectDoctor(doctor); final booked = await appState.bookSelectedDoctor(); if (booked && context.mounted) Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PatientQueueScreen())); } : null, child: Text(doctor.isActive ? 'Book' : 'Unavailable')));
    })])));
  }
}
