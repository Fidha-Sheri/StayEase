import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../warden_home.dart';

class WardenEventsPage extends StatefulWidget {
  const WardenEventsPage({super.key});

  @override
  State<WardenEventsPage> createState() => _WardenEventsPageState();
}

class _WardenEventsPageState extends State<WardenEventsPage> {
  int _selectedIndex = 1;

  final CollectionReference _eventsRef =
      FirebaseFirestore.instance.collection('events');

  void _onNavBarTap(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const WardenHome()));
    }
  }

  // ---------------- ADD / EDIT ----------------
  Future<void> addOrEditEvent({DocumentSnapshot? event}) async {
    final titleController =
        TextEditingController(text: event?['title'] ?? '');
    final descController =
        TextEditingController(text: event?['desc'] ?? '');

    DateTime? selectedDate;
    if (event != null && event['date'] is Timestamp) {
      selectedDate = (event['date'] as Timestamp).toDate();
    }

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(event == null ? 'Add Event' : 'Edit Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title')),
              TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(selectedDate != null
                      ? 'Date: ${selectedDate.toString().split(' ')[0]}'
                      : 'Date: Not selected'),
                  const Spacer(),
                  TextButton(
                    child: const Text('Select'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setStateDialog(() => selectedDate = picked);
                      }
                    },
                  )
                ],
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
              child: Text(event == null ? 'Add' : 'Save'),
              onPressed: () {
                if (titleController.text.isEmpty ||
                    descController.text.isEmpty ||
                    selectedDate == null) return;

                final data = {
                  'title': titleController.text,
                  'desc': descController.text,
                  'date': Timestamp.fromDate(selectedDate!),
                  'addedBy': 'warden',
                };

                if (event == null) {
                  _eventsRef.add(data);
                } else {
                  _eventsRef.doc(event.id).update(data);
                }
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  // ---------------- CARD ----------------
  Widget eventCard(DocumentSnapshot e) {
    final data = e.data() as Map<String, dynamic>;
    final date = (data['date'] as Timestamp).toDate();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.event, color: Colors.blue),
        title: Text(data['title']),
        subtitle:
            Text('${date.toString().split(' ')[0]} • ${data['desc']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: const Icon(Icons.edit, color: Colors.green),
                onPressed: () => addOrEditEvent(event: e)),
            IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _eventsRef.doc(e.id).delete()),
          ],
        ),
      ),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
              onPressed: () => addOrEditEvent(),
              icon: const Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _eventsRef.orderBy('date').snapshots(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final events = snapshot.data!.docs;
          if (events.isEmpty) {
            return const Center(child: Text('No events found'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: events.length,
            itemBuilder: (_, i) => eventCard(events[i]),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        backgroundColor: Colors.blue[800],
        selectedItemColor: const Color.fromARGB(255, 253, 253, 253),
        unselectedItemColor: Colors.white60,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
        ],
      ),
    );
  }
}
