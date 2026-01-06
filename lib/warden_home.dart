import 'package:flutter/material.dart';

// Import all Warden feature pages
import 'wardenscreens/leave_approval_page.dart';
import 'wardenscreens/complaints_page.dart';
import 'wardenscreens/mess_menu_page.dart';
import 'wardenscreens/events_page.dart';
import 'wardenscreens/profile_page.dart';
import 'wardenscreens/feedback_page.dart'; // New Feedback Page

// Warden Home screen (after login)
class WardenHome extends StatefulWidget {
  const WardenHome({super.key});

  @override
  State<WardenHome> createState() => _WardenHomeState();
}

class _WardenHomeState extends State<WardenHome> {
  // Keeps track of the selected tab in bottom navigation bar
  int _selectedIndex = 0;

  // Called when a bottom navigation item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // If Profile is selected, navigate directly to ProfilePage
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pages list for BottomNavigationBar
    final List<Widget> pages = [
      _buildDashboard(context), // Home (Dashboard)
      Container(), // Placeholder for Profile (handled in navigation)
    ];

    return WillPopScope(
      // Prevent going back to Login screen using back button
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Removes default back button
          title: const Text(
            "Welcome",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[800],
        ),

        // Display the selected page (Home or Profile)
        body: pages[_selectedIndex],

        // Bottom Navigation Bar with Home and Profile options
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blue[800],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }

  /// -----------------------------------
  /// Dashboard (Grid with Warden features)
  /// -----------------------------------
  Widget _buildDashboard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2, // 2 cards per row
        crossAxisSpacing: 16, // horizontal spacing
        mainAxisSpacing: 16, // vertical spacing
        childAspectRatio: 1.0, // square-shaped cards
        children: [
          _buildDashboardCard(
            Icons.event_note,
            "Leave Approval",
            Colors.indigo.shade600,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeaveApprovalPage(),
                ),
              );
            },
          ),
          _buildDashboardCard(
            Icons.report_problem,
            "Complaints",
            Colors.redAccent.shade400,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ComplaintsPage(),
                ),
              );
            },
          ),
          _buildDashboardCard(
            Icons.restaurant_menu,
            "Mess Menu",
            Colors.teal.shade600,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessMenuPage(),
                ),
              );
            },
          ),
          _buildDashboardCard(
            Icons.event,
            "Events / Notices",
            Colors.purple.shade600,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WardenEventsPage(),
                ),
              );
            },
          ),
          _buildDashboardCard(
            Icons.feedback,
            "View Feedback",
            Colors.orange.shade600,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FeedbackPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// -----------------------------------
  /// Dashboard Card Helper Widget
  /// -----------------------------------
  Widget _buildDashboardCard(IconData icon, String title, Color color,
      {VoidCallback? onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5, // Shadow effect
      shadowColor: color.withOpacity(0.5),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap, // Action when card is tapped
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color], // Gradient background
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Card Icon
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 12),
              // Card Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
