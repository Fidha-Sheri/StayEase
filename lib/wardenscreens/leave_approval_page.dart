import 'package:flutter/material.dart';
import '../app_routes.dart'; // Make sure you have routes set up

class LeaveApprovalPage extends StatefulWidget {
  const LeaveApprovalPage({super.key});

  @override
  State<LeaveApprovalPage> createState() => _LeaveApprovalPageState();
}

class _LeaveApprovalPageState extends State<LeaveApprovalPage> {
  int _selectedIndex = 1; // Leave Approval tab is active

  // Sample leave requests
  final List<Map<String, String>> leaveRequests = [
    {
      "student": "Alice Johnson",
      "reason": "Medical",
      "from": "2025-10-01",
      "to": "2025-10-03"
    },
    {
      "student": "Bob Smith",
      "reason": "Family Function",
      "from": "2025-10-05",
      "to": "2025-10-06"
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Navigate to Warden Home
        Navigator.pushReplacementNamed(context, AppRoutes.homeWarden);
        break;
      case 1:
        // Current page (Leave Approval) - do nothing
        break;
      case 2:
        // Navigate to Warden Profile
        Navigator.pushReplacementNamed(context, AppRoutes.wardenProfile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Leave Approvals",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: leaveRequests.isEmpty
          ? const Center(
              child: Text(
                "No leave requests pending.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: leaveRequests.length,
              itemBuilder: (context, index) {
                final leave = leaveRequests[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          leave["student"]!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.note_alt, size: 16),
                            const SizedBox(width: 4),
                            Text("Reason: ${leave["reason"]}"),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.date_range, size: 16),
                            const SizedBox(width: 4),
                            Text("From: ${leave["from"]}  To: ${leave["to"]}"),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  leaveRequests.removeAt(index);
                                });
                              },
                              icon: const Icon(Icons.check),
                              label: const Text("Approve"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  leaveRequests.removeAt(index);
                                });
                              },
                              icon: const Icon(Icons.close),
                              label: const Text("Reject"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blue[800],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: "LeaveApproval"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
