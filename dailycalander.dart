import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HolidayCalendarPage extends StatefulWidget {
  const HolidayCalendarPage({super.key});

  @override
  State<HolidayCalendarPage> createState() => _HolidayCalendarPageState();
}

class _HolidayCalendarPageState extends State<HolidayCalendarPage> {
  DateTime currentMonth = DateTime.now();
  List<Map<String, dynamic>> holidays = [];
  bool isLoading = true;

  // Theme Colors
  final Color primaryDark = const Color(0xFF1A237E); // Simple Dark Blue
  final Color holidayRed = const Color(0xFFD32F2F); // Vibrant Red

  @override
  void initState() {
    super.initState();
    fetchHolidays();
  }

  Future<void> fetchHolidays() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('holidays')
          .orderBy('date')
          .get();

      List<Map<String, dynamic>> firestoreHolidays = snapshot.docs.map((doc) {
        return {
          'title': doc['title'],
          'date': (doc['date'] as Timestamp).toDate(),
          'type': doc.data().containsKey('type') ? doc['type'] : 'Public',
          'busRunning': doc.data().containsKey('busRunning') ? doc['busRunning'] : false,
        };
      }).toList();

      // --- ADD DEFAULT HOLIDAYS ---
      List<Map<String, dynamic>> defaultHolidays = [
        {
          'title': 'New Year\'s Day',
          'date': DateTime(currentMonth.year, 1, 1),
          'type': 'Public',
          'busRunning': false,
        },
        {
          'title': 'Christmas',
          'date': DateTime(currentMonth.year, 12, 25),
          'type': 'Public',
          'busRunning': false,
        },
        {
          'title': 'Diwali',
          'date': DateTime(currentMonth.year, 11, 1), // Change date according to year
          'type': 'Public',
          'busRunning': false,
        },
        {
          'title': 'Holi',
          'date': DateTime(currentMonth.year, 3, 8), // Change date according to year
          'type': 'Public',
          'busRunning': false,
        },
        {
          'title': 'Independence Day',
          'date': DateTime(currentMonth.year, 8, 15),
          'type': 'Public',
          'busRunning': false,
        },
      ];

      setState(() {
        holidays = [...firestoreHolidays, ...defaultHolidays];
        holidays.sort((a, b) => a['date'].compareTo(b['date'])); // Sort by date
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: primaryDark,
        elevation: 0,
        title: Text("Holiday Calendar",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryDark))
          : SingleChildScrollView(
        child: Column(
          children: [
            _buildMonthPicker(),
            _buildCalendarGrid(),
            _buildLegend(),
            _buildHolidayList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthPicker() {
    return Container(
      color: primaryDark,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
            onPressed: () => setState(() => currentMonth = DateTime(currentMonth.year, currentMonth.month - 1)),
          ),
          Text(
            DateFormat('MMMM yyyy').format(currentMonth).toUpperCase(),
            style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
            onPressed: () => setState(() => currentMonth = DateTime(currentMonth.year, currentMonth.month + 1)),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final totalDays = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final int emptyBefore = firstDay.weekday - 1;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildWeekHeader(),
          const Divider(),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: emptyBefore + totalDays,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7, mainAxisSpacing: 5, crossAxisSpacing: 5),
            itemBuilder: (context, index) {
              if (index < emptyBefore) return const SizedBox();

              final day = index - emptyBefore + 1;
              final date = DateTime(currentMonth.year, currentMonth.month, day);
              final isToday = DateFormat('yMd').format(date) == DateFormat('yMd').format(DateTime.now());

              final holiday = holidays.firstWhere(
                    (h) => DateFormat('yMd').format(h['date']) == DateFormat('yMd').format(date),
                orElse: () => {},
              );

              bool isHoliday = holiday.isNotEmpty;

              return Container(
                decoration: BoxDecoration(
                  color: isHoliday ? holidayRed.withOpacity(0.1) : (isToday ? primaryDark : Colors.transparent),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isHoliday ? holidayRed : (isToday ? primaryDark : Colors.transparent),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      fontWeight: (isToday || isHoliday) ? FontWeight.bold : FontWeight.normal,
                      color: isToday ? Colors.white : (isHoliday ? holidayRed : Colors.black87),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekHeader() {
    const days = ["M", "T", "W", "T", "F", "S", "S"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((d) => Text(d, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))).toList(),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _dot(holidayRed, "Holiday"),
          const SizedBox(width: 20),
          _dot(primaryDark, "Today"),
        ],
      ),
    );
  }

  Widget _dot(Color color, String label) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }

  Widget _buildHolidayList() {
    final monthHolidays = holidays.where((h) => h['date'].month == currentMonth.month && h['date'].year == currentMonth.year).toList();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("UPCOMING EVENTS", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
          const SizedBox(height: 15),
          if (monthHolidays.isEmpty)
            const Center(child: Text("No holidays this month", style: TextStyle(color: Colors.grey)))
          else
            ...monthHolidays.map((h) => _holidayTile(h)).toList(),
        ],
      ),
    );
  }

  Widget _holidayTile(Map<String, dynamic> h) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: holidayRed, width: 5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
      ),
      child: ListTile(
        title: Text(h['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(DateFormat('EEEE, dd MMM').format(h['date'])),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: h['busRunning'] ? Colors.green.withOpacity(0.1) : holidayRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            h['busRunning'] ? "BUS RUNNING" : "BUS CLOSED",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: h['busRunning'] ? Colors.green : holidayRed),
          ),
        ),
      ),
    );
  }
}
