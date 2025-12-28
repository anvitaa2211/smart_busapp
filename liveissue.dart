import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiveIssuesPage extends StatelessWidget {
  const LiveIssuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Issues")),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("issues")
            .orderBy("timestamp", descending: true)
            .snapshots(), // 🔥 REAL TIME
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No issues reported"));
          }

          final issues = snapshot.data!.docs;

          return ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, index) {
              final issue = issues[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Icon(
                    Icons.report_problem,
                    color: issue["status"] == "Solved"
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text(issue["title"]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(issue["description"]),
                      const SizedBox(height: 5),
                      Text("Category: ${issue["category"]}"),
                      Text("Status: ${issue["status"]}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
