import 'package:flutter/material.dart';
import '../admin_home.dart';
import 'profile_page.dart';

class WardenManagementPage extends StatefulWidget {
  const WardenManagementPage({super.key});

  @override
  State<WardenManagementPage> createState() => _WardenManagementPageState();
}

class _WardenManagementPageState extends State<WardenManagementPage> {
  List<Map<String, dynamic>> wardens = [
    {"name": "John Doe", "email": "john@gmail.com", "gender": "Male"},
    {"name": "Mary Jane", "email": "mary@gmail.com", "gender": "Female"},
    {"name": "Robert Smith", "email": "robert@gmail.com", "gender": "Male"},
    {"name": "Linda Brown", "email": "linda@gmail.com", "gender": "Female"},
  ];

  int _selectedIndex = 1; // 0 = Home, 1 = Wardens, 2 = Profile

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
        title: const Text("Warden Management"),
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
                fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor),
            dataTextStyle: const TextStyle(fontSize: 14),
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Gender')),
              DataColumn(label: SizedBox()),
            ],
            rows: wardens.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> warden = entry.value;

              return DataRow(
                cells: [
                  DataCell(Text(warden["name"])),
                  DataCell(Text(warden["email"])),
                  DataCell(Text(warden["gender"])),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete, color: primaryColor, size: 24),
                      onPressed: () {
                        setState(() {
                          wardens.removeAt(index);
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
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Wardens"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
