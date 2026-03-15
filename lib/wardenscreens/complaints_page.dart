import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../warden_home.dart';

class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  int _selectedIndex = 1;

  Future<void> _markAsSolved(String docId) async {
    await FirebaseFirestore.instance
        .collection('complaints')
        .doc(docId)
        .update({'resolved': true});
  }

  Color _statusColor(bool resolved) {
    return resolved ? Colors.green : Colors.red;
  }

  Widget _buildColumnHeader(String title, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.blue[200],
        border: Border.all(color: Colors.blue, width: 0.5),
      ),
      child: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildCell(String text, double width,
      {Color? bgColor, TextAlign align = TextAlign.left}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Text(
        text,
        textAlign: align,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Student Complaints",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          if (snapshot.data!.docs.isEmpty) return const Center(child: Text("No complaints"));

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Row(
                  children: [
                    _buildColumnHeader("Student Email", 200),
                    _buildColumnHeader("Title", 150),
                    _buildColumnHeader("Complaint", 300),
                    _buildColumnHeader("Status", 120),
                    _buildColumnHeader("Action", 180),
                  ],
                ),
                ...snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final email = data['studentEmail'] ?? 'No email';
                  final title = data['title'] ?? '';
                  final complaint = data['complaint'] ?? '';
                  final resolved = data['resolved'] ?? false;

                  return Row(
                    children: [
                      _buildCell(email, 200),
                      _buildCell(title, 150),
                      _buildCell(complaint, 300),
                      _buildCell(
                        resolved ? "Solved" : "Unsolved",
                        120,
                        bgColor: _statusColor(resolved).withOpacity(0.2),
                        align: TextAlign.center,
                      ),
                      Container(
                        width: 180,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                        child: resolved
                            ? const Center(child: Text("-"))
                            : ElevatedButton(
                                onPressed: () => _markAsSolved(doc.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  textStyle: const TextStyle(fontSize: 12),
                                ),
                                child: const Text("Mark Solved"),
                              ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 0) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const WardenHome()));
          }
        },
        backgroundColor: Colors.blue[800],
        selectedItemColor: const Color.fromARGB(255, 253, 253, 253),
        unselectedItemColor: Colors.white60,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: "Complaints"),
        ],
      ),
    );
  }
}
