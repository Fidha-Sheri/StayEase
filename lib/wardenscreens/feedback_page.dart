import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../warden_home.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const WardenHome()),
      );
    }
  }

  Widget buildStars(int rating) {
    return Row(
      children: List.generate(
        rating,
        (index) => const Icon(Icons.star, color: Colors.amber, size: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Student Feedback"),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feedback')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final feedbackList = snapshot.data!.docs;

          if (feedbackList.isEmpty) {
            return const Center(child: Text("No feedback yet"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: feedbackList.length,
            itemBuilder: (context, index) {
              final data = feedbackList[index].data() as Map<String, dynamic>;

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 229, 231, 247),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['studentName'] ?? "Student",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(255, 61, 146, 243),
                      ),
                    ),
                    const SizedBox(height: 5),
                    buildStars(data['rating'] ?? 0),
                    const SizedBox(height: 8),
                    Text(data['message'] ?? ""),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.blue[800],
        selectedItemColor: const Color.fromARGB(255, 253, 253, 253),
        unselectedItemColor: Colors.white60,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.feedback), label: "Feedback"),
        ],
      ),
    );
  }
}
