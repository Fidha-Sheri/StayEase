import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_routes.dart';

class WardenMessMenuPage extends StatefulWidget {
  const WardenMessMenuPage({super.key});

  @override
  State<WardenMessMenuPage> createState() => _WardenMessMenuPageState();
}

class _WardenMessMenuPageState extends State<WardenMessMenuPage> {
  bool _loading = false;
  List<Map<String, dynamic>> _weeklyMenu = [];
  int _selectedIndex = 1; // 0 = Home, 1 = Mess Menu

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
          'docId': doc.id,
          'meals': List<Map<String, dynamic>>.from(doc['meals']),
        };
      }).toList();
    } catch (e) {
      debugPrint("Error fetching menu: $e");
    }

    setState(() => _loading = false);
  }

  // 🔹 SAME MEAL CARD UI + EDIT BUTTON
  Widget mealCard(String docId, Map<String, dynamic> meal, List meals) {
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
                      fontSize: 18, fontWeight: FontWeight.bold),
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
            onPressed: () => editMeal(docId, meal, meals),
          ),
        ],
      ),
    );
  }

  // 🔹 DAY CARD
  Widget dayCard(Map<String, dynamic> day) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              day['day'],
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...day['meals'].map<Widget>((meal) => mealCard(
                  day['docId'],
                  meal,
                  day['meals'],
                )),
          ],
        ),
      ),
    );
  }

  // 🔹 EDIT DIALOG
  void editMeal(String docId, Map<String, dynamic> meal, List meals) {
    final controller =
        TextEditingController(text: meal['items'].join(', '));

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit ${meal['type']}'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Comma separated items',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              meal['items'] =
                  controller.text.split(',').map((e) => e.trim()).toList();

              await FirebaseFirestore.instance
                  .collection('mess_menu')
                  .doc(docId)
                  .update({'meals': meals});

              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warden Mess Menu'),
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
                itemBuilder: (context, index) =>
                    dayCard(_weeklyMenu[index]),
              ),
            ),
      // -------- BOTTOM NAV (HOME & MESS MENU) --------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);

          if (index == 0) {
            Navigator.pushReplacementNamed(context, AppRoutes.homeWarden);
          }
        },
        backgroundColor: Colors.blue[800],
        selectedItemColor: const Color.fromARGB(255, 253, 253, 253),
        unselectedItemColor: Colors.white60,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: "Mess Menu"),
        ],
      ),
    );
  }
}
