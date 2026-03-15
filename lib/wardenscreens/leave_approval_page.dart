import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../app_routes.dart';

class LeaveApprovalPage extends StatefulWidget {
  const LeaveApprovalPage({super.key});

  @override
  State<LeaveApprovalPage> createState() => _LeaveApprovalPageState();
}

class _LeaveApprovalPageState extends State<LeaveApprovalPage> {
  int _selectedIndex = 1;

  // -------- UPDATE STATUS --------
  Future<void> _updateStatus(String docId, String status) async {
    await FirebaseFirestore.instance
        .collection('leave_requests')
        .doc(docId)
        .update({'status': status});
  }

  Color _statusColor(String status) {
    if (status == 'approved') return Colors.green;
    if (status == 'rejected') return Colors.red;
    return Colors.orange;
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
          "Leave Approvals",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('leave_requests')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No leave requests"));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                // ----------------- TABLE HEADER -----------------
                Row(
                  children: [
                    _buildColumnHeader("Student Email", 180),
                    _buildColumnHeader("From", 100),
                    _buildColumnHeader("To", 100),
                    _buildColumnHeader("Reason", 250),
                    _buildColumnHeader("Status", 100),
                    _buildColumnHeader("Action", 180),
                  ],
                ),
                // ----------------- TABLE ROWS -----------------
                ...snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final from = (data['from'] as Timestamp).toDate();
                  final to = (data['to'] as Timestamp).toDate();
                  final status = data['status'] ?? 'pending';

                  return Row(
                    children: [
                      _buildCell(data['studentEmail'], 180),
                      _buildCell(DateFormat('dd MMM yyyy').format(from), 100),
                      _buildCell(DateFormat('dd MMM yyyy').format(to), 100),
                      _buildCell(data['reason'], 250),
                      _buildCell(
                        status.toUpperCase(),
                        100,
                        bgColor: _statusColor(status).withOpacity(0.2),
                        align: TextAlign.center,
                      ),
                      Container(
                        width: 180,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 6),
                        child: status == 'pending'
                            ? Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          _updateStatus(doc.id, 'approved'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        textStyle:
                                            const TextStyle(fontSize: 12),
                                      ),
                                      child: const Text("Approve"),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          _updateStatus(doc.id, 'rejected'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        textStyle:
                                            const TextStyle(fontSize: 12),
                                      ),
                                      child: const Text("Reject"),
                                    ),
                                  ),
                                ],
                              )
                            : const Center(child: Text("-")),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
      // -------- BOTTOM NAV (ONLY HOME & LEAVE APPROVAL) --------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.homeWarden);
          }
        },
        backgroundColor: Colors.blue[800],
        selectedItemColor: const Color.fromARGB(255, 253, 253, 253),
        unselectedItemColor: Colors.white60,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.table_chart), label: "Leave Approval"),
        ],
      ),
    );
  }
}
