import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    setState(() => userData = doc.data());
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("My Profile", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF0D1B2A),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 15),
            Text(userData!['name'], style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(userData!['email'], style: GoogleFonts.poppins(color: Colors.grey)),
            const SizedBox(height: 30),
            const Divider(thickness: 1, indent: 20, endIndent: 20),

            _simpleTile("PRN Number", userData!['prn'], 'prn', Icons.badge_outlined),
            _simpleTile("Phone", userData!['phone'], 'phone', Icons.phone_outlined),
            _simpleTile("Branch", userData!['branch'] ?? "Not Set", 'branch', Icons.school_outlined),
            _simpleTile("Bus Stop", userData!['busStop'] ?? "Not Set", 'busStop', Icons.location_on_outlined),
          ],
        ),
      ),
    );
  }

  Widget _simpleTile(String title, String value, String field, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0D1B2A)),
      title: Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () => _editField(title, field, value),
    );
  }

  void _editField(String title, String field, String value) {
    final controller = TextEditingController(text: value);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Update $title", style: const TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: controller, decoration: const InputDecoration(hintText: "Enter new value")),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D1B2A)),
              onPressed: () async {
                await _firestore.collection('users').doc(_auth.currentUser!.uid).update({field: controller.text});
                loadUser();
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}