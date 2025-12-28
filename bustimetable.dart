import 'package:flutter/material.dart';

class TimeTablePage extends StatelessWidget {
  final List<Map<String, String>> timetable = [
    {
      "day": "Monday",
      "date": "24 Nov 2025",
      "time": "8:00 AM - 9:00 AM",
      "subject": "Bus Route: Ashok Chowk→ College"
    },
    {
      "day": "Tuesday",
      "date": "25 Nov 2025",
      "time": "9:00 AM - 10:00 AM",
      "subject": "Bus Route: Saat Rasta → College"
    },
    {
      "day": "Wednesday",
      "date": "26 Nov 2025",
      "time": "10:00 AM - 11:00 AM",
      "subject": "Bus Route: Saiful → College"
    },
    {
      "day": "Thursday",
      "date": "27 Nov 2025",
      "time": "8:30 AM - 9:30 AM",
      "subject": "Bus Route: Dmart → College"
    },
    {
      "day": "Friday",
      "date": "28 Nov 2025",
      "time": "9:30 AM - 10:30 AM",
      "subject": "Bus Route: Vasant Vihar → College"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,

      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Bus Time Table"),
      ),

      body: ListView.builder(
        itemCount: timetable.length,
        padding: EdgeInsets.all(15),
        itemBuilder: (context, index) {
          var entry = timetable[index];

          return Container(
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  color: Colors.black12,
                  offset: Offset(2, 4),
                )
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: Colors.blue.shade700),
                    SizedBox(width: 8),
                    Text(
                      "${entry['day']} • ${entry['date']}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.blue.shade700),
                    SizedBox(width: 8),
                    Text(
                      entry["time"]!,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.directions_bus, color: Colors.blue.shade700),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry["subject"]!,
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}