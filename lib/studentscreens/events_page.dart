import 'package:flutter/material.dart';
import '../student_home.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  bool _loading = false;

  // Sample events
  final List<Map<String, String>> _events = [
    {
      'title': 'Christmas Day Celebration',
      'date': '2025-12-25',
      'desc': 'Special cultural events with gifts and decorations.'
    },
    {
      'title': 'New Year Celebration',
      'date': '2026-01-01',
      'desc': 'Countdown and cultural programs to welcome the new year.'
    },
  ];

  int _selectedIndex = 1; // 0 = Home, 1 = Events

  Future<void> fetchEventsFromApi() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() => _loading = false);
  }

  void _onNavBarTap(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudentHome()),
      );
    }
  }

  Widget eventCard(Map<String, String> e) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.event, color: Colors.blue, size: 28),
        ),
        title: Text(
          e['title']!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.blue,
          ),
        ),
        subtitle: Text('${e['date']} • ${e['desc']}'),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(e['title']!),
              content: Text('${e['date']}\n\n${e['desc']}'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostel Events & Notices'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 91, 162, 233),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchEventsFromApi,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _events.length,
                itemBuilder: (context, index) {
                  return eventCard(_events[index]);
                },
              ),
            ),

      // 🔽 Bottom Navigation (ONLY 2 ITEMS)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
        ],
      ),
    );
  }
}
