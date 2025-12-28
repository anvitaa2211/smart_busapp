import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smart_bus_app/Map.dart';
import 'package:smart_bus_app/busfeepage.dart';
import 'package:smart_bus_app/busroutedeatil.dart';
import 'package:smart_bus_app/bustimetable.dart';
import 'package:smart_bus_app/dailycalander.dart';
import 'package:smart_bus_app/profile.dart';
import 'package:smart_bus_app/reportissue.dart';
import 'package:smart_bus_app/setting.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required String role});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> busModules = [
      {
        'icon': Icons.directions_bus,
        'title': 'Route Details',
        'subtitle': 'Find your daily bus routes easily.',
        'page': RouteDetailsPage(),
      },
      {
        'icon': Icons.schedule,
        'title': 'Bus Timetable',
        'subtitle': 'Check timings of all college buses.',
        'page': TimeTablePage(),
      },
      {
        'icon': Icons.payment,
        'title': 'Bus Fees',
        'subtitle': 'Pay and view your bus fee status.',
        'page': BusFeePage(),
      },
      {
        'icon': Icons.report_problem,
        'title': 'Report Issue',
        'subtitle': 'Report late or missed buses.',
        'page': ReportIssuePage(),
      },
      {
        'icon': Icons.emoji_events,
        'title': 'Holiday Calender',
        'subtitle': 'See updates',
        'page': HolidayCalendarPage(),
      },
    ];

    final List<String> collegeImages = [
      'assets/images/img1.jpg',
      'assets/images/img2.jpg',
      'assets/images/img3.jpg',
    ];

    final List<Map<String, String>> upcomingTrips = [
      {'title': 'Industrial Visit', 'date': '15 Nov 2025'},
      {'title': 'Cultural Fest', 'date': '20 Nov 2025'},
      {'title': 'Tech Symposium', 'date': '28 Nov 2025'},
    ];

    final List<String> announcements = [
      "🚌 New route added: Solapur - Akkalkot",
      "🎓 Smart Bus ID card registration now open!",
      "⚙️ Maintenance on 5th Nov: Limited buses available",
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF003366), Color(0xFF6699CC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: const Icon(Icons.directions_bus, color: Colors.white, size: 45),
                            ),
                            const SizedBox(width: 18),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SMART BUS',
                                  style: GoogleFonts.montserrat(
                                    color: const Color(0xFFFFD700),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  'COLLEGE',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Color(0xFF003366), size: 20),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "🚍 Quick Access",
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    height: 210,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: busModules.length,
                      padding: const EdgeInsets.only(left: 20),
                      itemBuilder: (context, index) {
                        final module = busModules[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => module['page']),
                            );
                          },
                          child: Container(
                            width: 250,
                            margin: const EdgeInsets.only(right: 20),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: const Color(0xFFFFD700),
                                  radius: 25,
                                  child: Icon(module['icon'], color: const Color(0xFF003366), size: 30),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  module['title'],
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    color: const Color(0xFF003366),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  module['subtitle'],
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "🎓 College Activities",
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  CarouselSlider(
                    items: collegeImages
                        .map(
                          (path) => ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          path,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.25,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.broken_image, color: Colors.grey, size: 60),
                            ),
                          ),
                        ),
                      ),
                    )
                        .toList(),
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.25,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      aspectRatio: 16 / 9,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "🗓️ Upcoming College Trips",
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  ...upcomingTrips.map((trip) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(trip['title']!,
                              style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF003366))),
                          Text(trip['date']!,
                              style: GoogleFonts.openSans(fontSize: 15, color: Colors.grey[700])),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "📢 Announcements",
                      style: GoogleFonts.montserrat(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 20),
                      itemCount: announcements.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              announcements[index],
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF003366),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF003366),
        unselectedItemColor: Colors.grey,
        iconSize: 30,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: 0,

        onTap: (index) {
          if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => BusMapScreen()));
          }

          if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          }
          if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
          }
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }
}
