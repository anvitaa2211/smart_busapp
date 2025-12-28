import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String selectedCategory = "Bus Delay";
  final List<Map<String, dynamic>> categories = [
    {"name": "Bus Delay", "icon": Icons.access_time_rounded},
    {"name": "Driver Issue", "icon": Icons.person_outline_rounded},
    {"name": "Wrong Stop", "icon": Icons.wrong_location_rounded},
    {"name": "Cleanliness", "icon": Icons.cleaning_services_rounded},
    {"name": "Misconduct", "icon": Icons.gavel_rounded},
    {"name": "Other", "icon": Icons.more_horiz_rounded},
  ];

  bool isLoading = false;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  void _initNotifications() {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);
    _notificationsPlugin.initialize(settings);
  }

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'issue_channel', 'Issue Notifications',
      importance: Importance.high, priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await _notificationsPlugin.show(0, "Issue Submitted", "Our team has been notified.", details);
  }

  Future<void> submitIssue() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() => isLoading = true);
    await FirebaseFirestore.instance.collection("issues").add({
      "title": _titleController.text.trim(),
      "description": _descriptionController.text.trim(),
      "category": selectedCategory,
      "userId": user.uid,
      "userEmail": user.email,
      "status": "Pending",
      "timestamp": FieldValue.serverTimestamp(),
    });

    setState(() => isLoading = false);
    _titleController.clear();
    _descriptionController.clear();
    await _showNotification();
    _showSuccessSheet();
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 80),
            const SizedBox(height: 10),
            Text("Report Filed!", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("We are working on resolving your issue."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D1B2A)),
              child: const Text("Awesome", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        title: Text("Support Center", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderBanner(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select Category", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildCategoryChips(),
                  const SizedBox(height: 25),
                  _buildInputLabel("Issue Title"),
                  _buildTextField(_titleController, "Summarize the problem", 1),
                  const SizedBox(height: 20),
                  _buildInputLabel("Detailed Description"),
                  _buildTextField(_descriptionController, "Tell us more details...", 4),
                  const SizedBox(height: 40),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Color(0xFF0D1B2A),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("How can we help?", style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text("Reports are usually reviewed within 24 hours.", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((cat) {
        bool isSelected = selectedCategory == cat['name'];
        return GestureDetector(
          onTap: () => setState(() => selectedCategory = cat['name']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF4CC9F0) : Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
              boxShadow: isSelected ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8)] : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(cat['icon'], size: 18, color: isSelected ? Colors.white : Colors.blueGrey),
                const SizedBox(width: 8),
                Text(cat['name'], style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF0D1B2A))),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, int lines) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: TextField(
        controller: controller,
        maxLines: lines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D1B2A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
        ),
        onPressed: isLoading ? null : submitIssue,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text("SUBMIT REPORT", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
      ),
    );
  }
}