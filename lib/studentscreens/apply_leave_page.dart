import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../student_home.dart';

class ApplyLeavePage extends StatefulWidget {
  final String studentEmail;
  const ApplyLeavePage({super.key, required this.studentEmail});

  @override
  State<ApplyLeavePage> createState() => _ApplyLeavePageState();
}

class _ApplyLeavePageState extends State<ApplyLeavePage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _fromDate;
  DateTime? _toDate;
  final TextEditingController _reasonController = TextEditingController();
  bool _submitting = false;

  int _selectedIndex = 1; // BottomNav index: 0=Home, 1=Apply Leave

  // ---------- DATE PICKER ----------
  Future<void> _pickDate(bool isFrom) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );

    if (picked == null) return;

    setState(() {
      isFrom ? _fromDate = picked : _toDate = picked;
    });
  }

  // ---------- SUBMIT LEAVE ----------
  Future<void> _submitLeave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fromDate == null || _toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both dates')),
      );
      return;
    }

    setState(() => _submitting = true);

    try {
      await FirebaseFirestore.instance.collection('leave_requests').add({
        'studentId': FirebaseAuth.instance.currentUser!.uid,
        'studentEmail': widget.studentEmail,
        'reason': _reasonController.text.trim(),
        'from': Timestamp.fromDate(_fromDate!),
        'to': Timestamp.fromDate(_toDate!),
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      _reasonController.clear();
      setState(() {
        _fromDate = null;
        _toDate = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leave applied successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _submitting = false);
    }
  }

  // ---------- STUDENT LEAVES STREAM ----------
  Stream<QuerySnapshot> _myLeaves() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return FirebaseFirestore.instance
        .collection('leave_requests')
        .where('studentId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  String _format(DateTime? d) =>
      d == null ? 'Choose' : DateFormat('yyyy-MM-dd').format(d);

  Color _statusColor(String s) {
    if (s == 'approved') return Colors.green;
    if (s == 'rejected') return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Leave'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ---------- APPLY FORM ----------
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _pickDate(true),
                              child: Text('From: ${_format(_fromDate)}'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _pickDate(false),
                              child: Text('To: ${_format(_toDate)}'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Reason',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.trim().length < 5
                                ? 'Enter a valid reason'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      _submitting
                          ? const CircularProgressIndicator()
                          : ElevatedButton.icon(
                              onPressed: _submitLeave,
                              icon: const Icon(Icons.send),
                              label: const Text('Submit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 61, 142, 224),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ---------- MY LEAVES ----------
            const Text(
              "My Leave Requests",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Use Expanded with StreamBuilder to avoid layout issues
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _myLeaves(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No leave requests yet"));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final data = doc.data() as Map<String, dynamic>?;

                      if (data == null) return const SizedBox();

                      final from = (data['from'] as Timestamp).toDate();
                      final to = (data['to'] as Timestamp).toDate();
                      final status = data['status'] ?? 'pending';

                      return Card(
                        key: ValueKey(doc.id),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.event_note, color: Colors.blue),
                          title: Text(
                            "${DateFormat('dd MMM yyyy').format(from)} → "
                            "${DateFormat('dd MMM yyyy').format(to)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['reason'] ?? ''),
                              const SizedBox(height: 4),
                              Text(
                                "Status: ${status.toUpperCase()}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _statusColor(status),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.blue[800],
        selectedItemColor: const Color.fromARGB(255, 244, 245, 248),
        unselectedItemColor: Colors.white70,
        onTap: (i) {
          setState(() => _selectedIndex = i);
          if (i == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const StudentHome()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.note_alt), label: "Apply Leave"),
        ],
      ),
    );
  }
}
