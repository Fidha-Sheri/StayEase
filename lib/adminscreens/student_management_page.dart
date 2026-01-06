import 'package:flutter/material.dart';
import '../admin_home.dart';
import 'profile_page.dart';

class StudentManagementPage extends StatefulWidget {
  const StudentManagementPage({super.key});

  @override
  State<StudentManagementPage> createState() => _StudentManagementPageState();
}

class _StudentManagementPageState extends State<StudentManagementPage> {
  List<Map<String, dynamic>> students = [
    {"name": "Alice", "email": "alice@gmail.com", "gender": "Female"},
    {"name": "Bob", "email": "bob@gmail.com", "gender": "Male"},
    {"name": "Charlie", "email": "charlie@gmail.com", "gender": "Male"},
    {"name": "Debbie", "email": "debbie@example.com", "gender": "Female"},
  ];

  int _selectedIndex = 1; // 0 = Home, 1 = Students, 2 = Profile

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
        title: const Text("Student Management"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 30,
            headingRowHeight: 40,
            dataRowHeight: 45,
            headingTextStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
            dataTextStyle: const TextStyle(fontSize: 14),
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Gender')),
              DataColumn(label: SizedBox()), // Delete column
            ],
            rows: students.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> student = entry.value;

              return DataRow(
                cells: [
                  DataCell(Text(student["name"])),
                  DataCell(Text(student["email"])),
                  DataCell(Text(student["gender"])),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete, color: primaryColor, size: 24),
                      onPressed: () {
                        setState(() {
                          students.removeAt(index);
                        });
                      },
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
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Students"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
