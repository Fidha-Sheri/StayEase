import 'package:flutter/material.dart';

import 'studentscreens/mess_menu_page.dart';
import 'studentscreens/apply_leave_page.dart';
import 'studentscreens/complaints_page.dart';
import 'studentscreens/fee_status_page.dart';
import 'studentscreens/events_page.dart';
import 'studentscreens/profile_page.dart';
import 'studentscreens/feedback_page.dart';

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  int _selectedIndex = 0;

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
        appBar: AppBar(
          title: const Text('Welcome'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 71, 195, 225),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFF1E88E5),
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- DASHBOARD ----------------
  Widget _dashboard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _card(
            icon: Icons.restaurant_menu,
            title: 'Mess Menu',
            color1: const Color(0xFF90CAF9),
            color2: const Color(0xFF1E88E5),
            page: const MessMenuPage(),
          ),
          _card(
            icon: Icons.note_add,
            title: 'Apply Leave',
            color1: const Color(0xFF81D4FA),
            color2: const Color(0xFF039BE5),
            page: const ApplyLeavePage(),
          ),
          _card(
            icon: Icons.report_problem,
            title: 'Complaints',
            color1: const Color(0xFF80CBC4),
            color2: const Color(0xFF00897B),
            page: const ComplaintsPage(),
          ),
          _card(
            icon: Icons.account_balance_wallet,
            title: 'Fee Status',
            color1: const Color(0xFF9FA8DA),
            color2: const Color(0xFF3F51B5),
            page: const FeeStatusPage(),
          ),
          _card(
            icon: Icons.event,
            title: 'Events',
            color1: const Color(0xFF64B5F6),
            color2: const Color(0xFF1565C0),
            page: const EventsPage(),
          ),
          _card(
            icon: Icons.feedback,
            title: 'Feedback',
            color1: const Color(0xFFFFCC80),
            color2: const Color(0xFFFB8C00),
            page: const FeedbackPage(),
          ),
        ],
      ),
    );
  }

  // ---------------- CARD ----------------
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
