import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool busArrivalAlerts = false;
  bool scheduleUpdates = false;
  bool isLoading = true;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }

  Future<void> _loadUserSettings() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    if (doc.exists) {
      setState(() {
        busArrivalAlerts = doc.data()?['busArrivalAlerts'] ?? false;
        scheduleUpdates = doc.data()?['scheduleUpdates'] ?? false;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateSetting(String key, bool value) async {
    if (user == null) return;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
      key: value,
    }, SetOptions(merge: true));
  }

  Future<void> _changePassword() async {
    if (user == null) return;
    final TextEditingController _passController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D1B2A),
        title: const Text("Change Password", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _passController,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "New Password",
            hintStyle: TextStyle(color: Colors.white70),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.redAccent)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () async {
              try {
                await user!.updatePassword(_passController.text.trim());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password updated successfully")),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D1B2A),
        body: Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          _header("Notifications"),
          _switchTile("Bus Arrival Alerts", busArrivalAlerts, (v) {
            setState(() => busArrivalAlerts = v);
            _updateSetting('busArrivalAlerts', v);
          }),
          _switchTile("Schedule Updates", scheduleUpdates, (v) {
            setState(() => scheduleUpdates = v);
            _updateSetting('scheduleUpdates', v);
          }),
          const Divider(color: Colors.white38),
          _header("Account"),
          _actionTile("Change Password", Icons.lock_outline, _changePassword),
          _actionTile("Privacy Policy", Icons.privacy_tip_outlined, () {
            // Navigate to privacy policy page or open URL
          }),
          const SizedBox(height: 30),
          Center(
            child: TextButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              child: const Text("Sign Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _header(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Text(
        text,
        style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  Widget _switchTile(String title, bool val, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: val,
      onChanged: onChanged,
      activeColor: Colors.blueAccent,
      inactiveThumbColor: Colors.white54,
      inactiveTrackColor: Colors.white24,
    );
  }

  Widget _actionTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white70),
      onTap: onTap,
    );
  }
}
