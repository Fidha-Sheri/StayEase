import 'package:flutter/material.dart';
import '../student_home.dart';

class MessMenuPage extends StatefulWidget {
  const MessMenuPage({super.key});

  @override
  State<MessMenuPage> createState() => _MessMenuPageState();
}

class _MessMenuPageState extends State<MessMenuPage> {
  bool _loading = false;

  final List<String> weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  late final List<Map<String, dynamic>> _weeklyMenu;

  int _selectedIndex = 1; // Mess Menu selected

  @override
  void initState() {
    super.initState();
    _weeklyMenu = weekdays.map((day) {
      return {
        'day': day,
        'meals': [
          {
            'type': 'Breakfast',
            'items': ['Idli', 'Sambar', 'Chutney']
          },
          {
            'type': 'Lunch',
            'items': ['Rice', 'Chicken Curry', 'Vegetables']
          },
          {
            'type': 'Dinner',
            'items': ['Chapati', 'Paneer Butter Masala', 'Salad']
          },
        ]
      };
    }).toList();
  }

  Future<void> fetchMenuFromApi() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() => _loading = false);
  }

  void _onNavBarTap(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudentHome()),
      );
    }
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
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['type'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  (meal['items'] as List).join(', '),
                  style: const TextStyle(fontSize: 16),
                ),
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day['day'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...day['meals'].map<Widget>(mealCard).toList(),
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
        backgroundColor: Colors.blue.shade700,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchMenuFromApi,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _weeklyMenu.length,
                itemBuilder: (context, index) {
                  return dayCard(_weeklyMenu[index]);
                },
              ),
            ),

      // 🔽 Bottom Navigation (ONLY 2 ITEMS)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Mess Menu',
          ),
        ],
      ),
    );
  }
}
