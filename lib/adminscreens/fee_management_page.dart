import 'package:flutter/material.dart';
import '../admin_home.dart';
import 'profile_page.dart';

class FeeManagementPage extends StatefulWidget {
  const FeeManagementPage({super.key});

  @override
  State<FeeManagementPage> createState() => _FeeManagementPageState();
}

class _FeeManagementPageState extends State<FeeManagementPage> {
  List<Map<String, dynamic>> students = [
    {"name": "Alice", "email": "alice@gmail.com", "paid": true},
    {"name": "Bob", "email": "bob@gmail.com", "paid": false},
    {"name": "Charlie", "email": "charlie@gmail.com", "paid": true},
    {"name": "Debbie", "email": "debbie@gmail.com", "paid": false},
  ];

  int _selectedIndex = 1; // 0 = Home, 1 = Fee, 2 = Profile

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminHome()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    }

    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Fee Management"),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 40,
            headingRowHeight: 50,
            dataRowHeight: 60,
            headingTextStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
            dataTextStyle: const TextStyle(fontSize: 16),
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Paid Status')),
            ],
            rows: students.map((student) {
              return DataRow(
                cells: [
                  DataCell(Text(student["name"])),
                  DataCell(Text(student["email"])),
                  DataCell(
                    Text(
                      student["paid"] ? "Paid" : "Not Paid",
                      style: TextStyle(
                        color: student["paid"] ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.payment), label: "Fee Status"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
