import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_routes.dart'; // make sure your routes are defined here

class StudentMessMenuPage extends StatefulWidget {
  const StudentMessMenuPage({super.key});

  @override
  State<StudentMessMenuPage> createState() => _StudentMessMenuPageState();
}

class _StudentMessMenuPageState extends State<StudentMessMenuPage> {
  bool _loading = false;
  List<Map<String, dynamic>> _weeklyMenu = [];
  int _selectedIndex = 1; // 0 = Home, 1 = Mess Menu

  final List<String> weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    setState(() => _loading = true);
    final collection = FirebaseFirestore.instance.collection('mess_menu');

    try {
      final snapshot = await collection.get();
      _weeklyMenu = snapshot.docs.map((doc) {
        return {
          'day': doc['day'],
          'meals': List<Map<String, dynamic>>.from(doc['meals']),
        };
      }).toList();
    } catch (e) {
      debugPrint("Error fetching menu: $e");
    }

    setState(() => _loading = false);
  }

  Widget mealCard(Map<String, dynamic> meal) {
    IconData icon;
    Color color;

    switch (meal['type']) {
      case 'Breakfast':
        icon = Icons.breakfast_dining;
        color = Colors.orange.shade200;
        break;
      case 'Lunch':
        icon = Icons.lunch_dining;
        color = Colors.green.shade200;
        break;
      case 'Dinner':
        icon = Icons.dinner_dining;
        color = Colors.blue.shade200;
        break;
      default:
        icon = Icons.restaurant;
        color = Colors.grey.shade300;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration:
                BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal['type'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text((meal['items'] as List).join(', '),
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dayCard(Map<String, dynamic> day) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(day['day'],
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...day['meals'].map<Widget>((meal) => mealCard(meal)).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mess Menu'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchMenu,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _weeklyMenu.length,
                itemBuilder: (context, index) => dayCard(_weeklyMenu[index]),
              ),
            ),
      // -------- BOTTOM NAVIGATION --------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.blue[800],
        selectedItemColor: const Color.fromARGB(255, 244, 245, 248),
        unselectedItemColor: Colors.white70,
        onTap: (index) {
          setState(() => _selectedIndex = index);

          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.homeStudent);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: "Mess Menu"),
        ],
      ),
    );
  }
}
