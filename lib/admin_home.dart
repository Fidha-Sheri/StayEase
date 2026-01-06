import 'package:flutter/material.dart';

// Import all Admin feature pages
import 'adminscreens/student_management_page.dart';
import 'adminscreens/warden_management_page.dart';
import 'adminscreens/fee_management_page.dart';
import 'adminscreens/profile_page.dart';

// Admin Home screen (after login)
class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _selectedIndex = 0;

  // Bottom navigation pages
  late final List<Widget> _pages = [
    _buildDashboard(context),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Disable Android back button
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            "Welcome, Admin!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
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

  /// ----------------------------
  /// Dashboard Grid
  /// ----------------------------
  static Widget _buildDashboard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
        children: [
          _buildDashboardCard(
            context,
            Icons.people,
            "Student Management",
            Colors.blue,
            const StudentManagementPage(),
          ),
          _buildDashboardCard(
            context,
            Icons.admin_panel_settings,
            "Warden Management",
            Colors.deepPurple,
            const WardenManagementPage(),
          ),
          _buildDashboardCard(
            context,
            Icons.attach_money,
            "Fee Management",
            Colors.green,
            const FeeManagementPage(),
          ),
        ],
      ),
    );
  }

  /// ----------------------------
  /// Dashboard Card Widget
  /// ----------------------------
  static Widget _buildDashboardCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    Widget page,
  ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
