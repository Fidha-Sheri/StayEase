import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../student_home.dart';

class StudentEventsPage extends StatefulWidget {
  const StudentEventsPage({super.key});

  @override
  State<StudentEventsPage> createState() => _StudentEventsPageState();
}

class _StudentEventsPageState extends State<StudentEventsPage> {
  int _selectedIndex = 1;

  final CollectionReference _eventsRef =
      FirebaseFirestore.instance.collection('events');

  // ---------------- NAVIGATION ----------------
  void _onNavBarTap(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudentHome()),
      );
    }
  }

  // ---------------- EVENT CARD ----------------
  Widget eventCard(QueryDocumentSnapshot e) {
    final data = e.data() as Map<String, dynamic>;

    DateTime? date;
    if (data['date'] != null && data['date'] is Timestamp) {
      date = (data['date'] as Timestamp).toDate();
    }

    final dateText =
        date != null ? date.toString().split(' ')[0] : 'Date not set';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.event, color: Colors.blue, size: 28),
        ),
        title: Text(
          data['title'] ?? 'No Title',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.blue,
          ),
        ),
        subtitle: Text(
          '$dateText • ${data['desc'] ?? ''}',
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(data['title'] ?? 'No Title'),
              content: Text(
                '$dateText\n\n${data['desc'] ?? ''}',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Events & Notices'),
        centerTitle: true,
        backgroundColor:  Colors.blue[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _eventsRef.orderBy('date').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No events available',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: events.length,
            itemBuilder: (_, index) => eventCard(events[index]),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        backgroundColor: Colors.blue[800],
        selectedItemColor: const Color.fromARGB(255, 244, 245, 248),
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.event), label: 'Events'),
        ],
      ),
    );
  }
}