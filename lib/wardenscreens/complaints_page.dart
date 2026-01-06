import 'package:flutter/material.dart';
import '../warden_home.dart'; // ✅ Import WardenHome
import 'profile_page.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  int _selectedIndex = 1; // 0 = Home, 1 = Complaints, 2 = Profile

  // Complaints data
  final List<Map<String, dynamic>> _complaints = [
    {
      "student": "Alice Johnson",
      "complaint": "Leaking faucet in room 101",
      "date": "2025-10-01",
      "resolved": false
    },
    {
      "student": "Bob Smith",
      "complaint": "Mess food quality issue",
      "date": "2025-10-03",
      "resolved": false
    },
  ];

  // Handle bottom navigation taps
  void _onNavBarTap(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WardenHome()),
        );
        break;
      case 1:
        // Already on ComplaintsPage → do nothing
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Complaints"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: _complaints.isEmpty
          ? const Center(
              child: Text(
                "No complaints available.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _complaints.length,
              itemBuilder: (context, index) {
                final complaint = _complaints[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  shadowColor: Colors.grey.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaint["student"],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          complaint["complaint"],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.date_range, size: 16),
                            const SizedBox(width: 4),
                            Text("Date: ${complaint["date"]}"),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.info_outline, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              "Status: ${complaint["resolved"] ? "Corrected" : "Not Corrected"}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: complaint["resolved"]
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              onPressed: complaint["resolved"]
                                  ? null
                                  : () {
                                      setState(() {
                                        complaint["resolved"] = true;
                                      });
                                    },
                              icon: const Icon(Icons.check),
                              label: const Text("Mark Corrected"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
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
        onTap: _onNavBarTap,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.report), label: 'Complaints'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
