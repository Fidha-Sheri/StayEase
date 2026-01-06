import 'package:flutter/material.dart';

// import your pages
import '../warden_home.dart';
import 'profile_page.dart';

class MessMenuPage extends StatefulWidget {
  const MessMenuPage({super.key});

  @override
  State<MessMenuPage> createState() => _WardenMessMenuPageState();
}

class _WardenMessMenuPageState extends State<MessMenuPage> {
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

  late List<Map<String, dynamic>> _weeklyMenu;

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
    // TODO: replace with API call
    setState(() => _loading = false);
  }

  void editMealItems(Map<String, dynamic> meal) async {
    final TextEditingController controller = TextEditingController(
      text: meal['items'].join(', '),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${meal['type']}'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Enter items separated by comma',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                meal['items'] =
                    controller.text.split(',').map((e) => e.trim()).toList();
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
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
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
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
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () => editMealItems(meal),
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
            ...List.generate(day['meals'].length, (i) {
              Map<String, dynamic> meal = day['meals'][i];
              meal['day'] = day['day'];
              return mealCard(meal);
            }),
          ],
        ),
      ),
    );
  }

  int _selectedIndex = 1; // 0=Home, 1=MessMenu, 2=Profile

  void _onNavBarTap(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WardenHome()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MessMenuPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warden Mess Menu'),
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
                  final day = _weeklyMenu[index];
                  return dayCard(day);
                },
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: 'Mess Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
