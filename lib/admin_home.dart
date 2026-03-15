import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'adminscreens/student_management_page.dart';
import 'adminscreens/warden_management_page.dart';
import 'adminscreens/profile_page.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  int _selectedIndex = 0;

  final user = FirebaseAuth.instance.currentUser;

  String adminName = "";

  @override
  void initState() {
    super.initState();
    getAdminData();
  }

  /// FETCH ADMIN DATA FROM FIRESTORE
  Future<void> getAdminData() async {

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      setState(() {
        adminName = doc['name'];
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {

    final pages = [
      _dashboard(),
      const ProfilePage(),
    ];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(

        backgroundColor: const Color(0xFFF5F9FF),

        /// APP BAR
        appBar: AppBar(
          title: Text(
            adminName.isEmpty
                ? "Welcome"
                : "Welcome, $adminName",
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[800],
          elevation: 0,
          automaticallyImplyLeading: false,
        ),

        body: pages[_selectedIndex],

        /// BOTTOM NAVIGATION
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.blue[800],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          items: const [

            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),

          ],
        ),
      ),
    );
  }

  /// ---------------- DASHBOARD ----------------
  Widget _dashboard() {

    return Padding(
      padding: const EdgeInsets.all(16),

      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,

        children: [

          _card(
            icon: Icons.people,
            title: "Student Management",
            color1: const Color(0xFF90CAF9),
            color2: const Color(0xFF1E88E5),
            page: const StudentManagementPage(),
          ),

          _card(
            icon: Icons.admin_panel_settings,
            title: "Warden Management",
            color1: const Color(0xFFB39DDB),
            color2: const Color(0xFF5E35B1),
            page: const WardenManagementPage(),
          ),

        ],
      ),
    );
  }

  /// ---------------- DASHBOARD CARD ----------------
  Widget _card({
    required IconData icon,
    required String title,
    required Color color1,
    required Color color2,
    required Widget page,
  }) {

    return InkWell(
      borderRadius: BorderRadius.circular(18),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },

      child: Container(

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          boxShadow: [
            BoxShadow(
              color: color2.withOpacity(0.3),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(icon, size: 42, color: Colors.white),

            const SizedBox(height: 12),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),

          ],
        ),
      ),
    );
  }
}