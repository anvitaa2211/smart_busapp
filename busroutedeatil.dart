import 'package:flutter/material.dart';

class RouteDetailsPage extends StatefulWidget {
  @override
  _RouteDetailsPageState createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {
  int? selectedBusIndex;

  final List<Map<String, dynamic>> buses = [
    {
      "busNumber": "SB-101",
      "driverName": "Ramesh Patil",
      "driverPhone": "9876543210",
      "route": [
        {"stop": "Solapur CBS", "arrival": "08:10 AM", "departure": "08:15 AM"},
        {"stop": "S.T. Stand", "arrival": "08:20 AM", "departure": "08:22 AM"},
        {"stop": "Saat Rasta", "arrival": "08:30 AM", "departure": "08:32 AM"},
        {"stop": "Hotgi Road", "arrival": "08:45 AM", "departure": "08:47 AM"},
        {"stop": "Orchid College Campus", "arrival": "09:00 AM", "departure": "-"},
      ]
    },

    {
      "busNumber": "SB-202",
      "driverName": "Suresh Mane",
      "driverPhone": "9012345678",
      "route": [
        {"stop": "Solapur Railway Station", "arrival": "07:50 AM", "departure": "07:55 AM"},
        {"stop": "Modi", "arrival": "08:05 AM", "departure": "08:07 AM"},
        {"stop": "Foujdar Chawl", "arrival": "08:20 AM", "departure": "08:22 AM"},
        {"stop": "Akkalkot Road", "arrival": "08:35 AM", "departure": "08:37 AM"},
        {"stop": "Orchid College Campus", "arrival": "09:00 AM", "departure": "-"},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,

      appBar: AppBar(
        title: Text("Route Details"),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),

      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),

        child: selectedBusIndex == null
            ? buildBusList()
            : buildBusDetails(buses[selectedBusIndex!]),
      ),
    );
  }


  Widget buildBusList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: buses.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            setState(() => selectedBusIndex = index);
          },

          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18)),
            margin: EdgeInsets.only(bottom: 20),

            child: Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue.shade700,
                    child: Icon(Icons.directions_bus,
                        color: Colors.white, size: 28),
                  ),
                  SizedBox(width: 20),
                  Text(
                    buses[index]["busNumber"],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget buildBusDetails(Map<String, dynamic> bus) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Back Button
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.blue.shade800),
                onPressed: () {
                  setState(() => selectedBusIndex = null);
                },
              ),

              Text(
                "Bus ${bus["busNumber"]}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),

          SizedBox(height: 20),


          Card(
            elevation: 4,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

            child: Padding(
              padding: EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, size: 30, color: Colors.blue.shade700),
                      SizedBox(width: 10),
                      Text(
                        bus["driverName"],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.green),
                      SizedBox(width: 10),
                      Text(
                        bus["driverPhone"],
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),

          // -----------------------------------------------------
          // ROUTE LIST TITLE
          // -----------------------------------------------------
          Text(
            "Route Stops",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),

          SizedBox(height: 10),


          Column(
            children: bus["route"].map<Widget>((routeItem) {
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                margin: EdgeInsets.only(bottom: 15),

                child: Padding(
                  padding: EdgeInsets.all(16),

                  child: Row(
                    children: [
                      Icon(Icons.location_on,
                          color: Colors.blue.shade700, size: 28),

                      SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              routeItem["stop"],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "Arrival: ${routeItem["arrival"]}   |   Departure: ${routeItem["departure"]}",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}