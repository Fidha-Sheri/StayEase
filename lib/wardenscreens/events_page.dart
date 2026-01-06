import 'package:flutter/material.dart';
import '../warden_home.dart';
import 'profile_page.dart';

class WardenEventsPage extends StatefulWidget {
  const WardenEventsPage({super.key});

  @override
  State<WardenEventsPage> createState() => _WardenEventsPageState();
}

class _WardenEventsPageState extends State<WardenEventsPage> {
  bool _loading = false;
  int _selectedIndex = 1; // Default to Events tab

  // Events data
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

  Future<void> fetchEventsFromApi() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    // TODO: Replace with API call to fetch events
    setState(() => _loading = false);
  }

  void addOrEditEvent({Map<String, String>? event, int? index}) {
    final titleController =
        TextEditingController(text: event != null ? event['title'] : '');
    final dateController =
        TextEditingController(text: event != null ? event['date'] : '');
    final descController =
        TextEditingController(text: event != null ? event['desc'] : '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(event == null ? 'Add Event' : 'Edit Event'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: dateController,
                decoration:
                    const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
              ),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newEvent = {
                'title': titleController.text,
                'date': dateController.text,
                'desc': descController.text,
              };
              setState(() {
                if (index != null) {
                  _events[index] = newEvent;
                } else {
                  _events.add(newEvent);
                }
              });
              Navigator.pop(context);
            },
            child: Text(event == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  void deleteEvent(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _events.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text('Delete')),
        ],
      ),
    );
  }

  Widget eventCard(Map<String, String> e, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(Icons.event, color: Colors.blue, size: 28),
        ),
        title: Text(
          e['title']!,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue),
        ),
        subtitle: Text('${e['date']} • ${e['desc']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () => addOrEditEvent(event: e, index: index),
                icon: const Icon(Icons.edit, color: Colors.green)),
            IconButton(
                onPressed: () => deleteEvent(index),
                icon: const Icon(Icons.delete, color: Colors.red)),
          ],
        ),
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
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // Return the page content based on the selected tab
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const WardenHome();
      case 1:
        return _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: fetchEventsFromApi,
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _events.length,
                  itemBuilder: (context, index) {
                    final e = _events[index];
                    return eventCard(e, index);
                  },
                ),
              );
      case 2:
        return const ProfilePage();
      default:
        return const SizedBox.shrink();
    }
  }

  // Return AppBar title based on selected tab
  String _getTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Manage Events & Notices';
      case 2:
        return 'Profile';
      default:
        return '';
    }
  }

  void _onNavBarTap(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WardenHome()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WardenEventsPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(_selectedIndex)),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
              onPressed: () => addOrEditEvent(),
              icon: const Icon(Icons.add, color: Colors.white))
        ],
      ),
      body: _getPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
