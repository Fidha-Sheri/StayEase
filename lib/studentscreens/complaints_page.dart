import 'package:flutter/material.dart';
import '../student_home.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _submitting = false;

  final List<Map<String, String>> _complaints = [
    {
      'title': 'Leaky Tap',
      'status': 'Open',
      'desc': 'Bathroom tap leaking since 2 days.'
    },
    {'title': 'Room Light', 'status': 'Resolved', 'desc': 'Light replaced.'},
  ];

  int _selectedIndex = 1; // 0 = Home, 1 = Complaints

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudentHome()),
      );
    }
  }

  Future<void> _submitComplaint() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _submitting = false;
      _complaints.insert(0, {
        'title': _titleCtrl.text.trim(),
        'status': 'Open',
        'desc': _descCtrl.text.trim(),
      });
      _titleCtrl.clear();
      _descCtrl.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Complaint submitted')),
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaints'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Complaint Form
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleCtrl,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descCtrl,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (v) => v == null || v.trim().length < 5
                            ? 'Write more'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      _submitting
                          ? const CircularProgressIndicator()
                          : ElevatedButton.icon(
                              onPressed: _submitComplaint,
                              icon: const Icon(Icons.send, color: Colors.white),
                              label: const Text(
                                'Submit',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _complaints.isEmpty ? 'No Complaints yet' : 'Your Complaints',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            // Complaints List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _complaints.length,
              itemBuilder: (_, i) {
                final c = _complaints[i];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(
                      c['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(c['desc']!),
                    trailing: Chip(
                      label: Text(c['status']!),
                      backgroundColor: c['status'] == 'Resolved'
                          ? Colors.green.shade100
                          : Colors.red.shade100,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // 🔽 Bottom Navigation (ONLY 2 ITEMS)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: "Complaints",
          ),
        ],
      ),
    );
  }
}
