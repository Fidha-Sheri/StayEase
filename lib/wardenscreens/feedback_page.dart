import 'package:flutter/material.dart';
import '../warden_home.dart';
import 'profile_page.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _MyFeedbackPageState();
}

class _MyFeedbackPageState extends State<FeedbackPage> {
  int _selectedIndex = 0;

  // Sample feedback list (replace with API/database)
  final List<Map<String, String>> feedbackList = const [
    {"student": "John Doe", "feedback": "Mess food quality is good."},
    {"student": "Jane Smith", "feedback": "Need more sports activities."},
    {
      "student": "Alice Johnson",
      "feedback": "Rooms are clean and well-maintained."
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigate to Home (Dashboard)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WardenHome(),
        ),
      );
    } else if (index == 1) {
      // Navigate to Profile
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Feedback"),
        backgroundColor: Colors.blue[800],
        automaticallyImplyLeading: false, // Remove default back button
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: feedbackList.length,
        itemBuilder: (context, index) {
          final feedback = feedbackList[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text(feedback['student']!),
              subtitle: Text(feedback['feedback']!),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue[800],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
