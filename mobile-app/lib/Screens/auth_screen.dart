import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:waitless/Screens/doctorlist.dart';
import 'package:waitless/app_state.dart';
import 'package:waitless/models.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'Male';
  bool _isLoading = false;
  @override
  void dispose() { _nameController.dispose(); _phoneController.dispose(); _ageController.dispose(); super.dispose(); }
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    context.read<AppState>().setPatient(PatientDetails(name: _nameController.text.trim(), phone: _phoneController.text.trim(), age: int.parse(_ageController.text), gender: _gender));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const DoctorListScreen()));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Book a token')),
    body: Padding(padding: const EdgeInsets.all(20), child: Form(key: _formKey, child: ListView(children: [
      const Text('Clinic Queue', style: TextStyle(letterSpacing: 1.5, color: Color(0xFF7D8187), fontSize: 12)),
      const SizedBox(height: 8), Text('Your details', style: GoogleFonts.outfit(fontSize: 30, fontWeight: FontWeight.w700)),
      const SizedBox(height: 6), const Text('Only the details needed to create your token are collected.', style: TextStyle(color: Color(0xFF6B7280))),
      const SizedBox(height: 24),
      TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name'), validator: (value) => value == null || value.trim().isEmpty ? 'Enter your name' : null),
      const SizedBox(height: 20),
      TextFormField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone number'), validator: (value) => value == null || value.trim().length < 5 ? 'Enter a valid phone number' : null),
      const SizedBox(height: 20),
      TextFormField(controller: _ageController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Age'), validator: (value) => int.tryParse(value ?? '') == null || int.parse(value!) < 1 ? 'Enter a valid age' : null),
      const SizedBox(height: 20),
      DropdownButtonFormField<String>(initialValue: _gender, decoration: const InputDecoration(labelText: 'Gender'), items: const [DropdownMenuItem(value: 'Male', child: Text('Male')), DropdownMenuItem(value: 'Female', child: Text('Female')), DropdownMenuItem(value: 'Other', child: Text('Other'))], onChanged: (value) => setState(() => _gender = value!)),
      const SizedBox(height: 30),
      ElevatedButton(onPressed: _isLoading ? null : _submit, child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Continue to token booking'))),
    ]))),
  );
}
