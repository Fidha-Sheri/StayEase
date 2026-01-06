import 'package:flutter/material.dart';
import '../student_home.dart';

class FeeStatusPage extends StatefulWidget {
  const FeeStatusPage({super.key});

  @override
  State<FeeStatusPage> createState() => _FeeStatusPageState();
}

class _FeeStatusPageState extends State<FeeStatusPage> {
  late double _monthlyFee;
  late double _dueAmount;
  late DateTime _dueDate;

  List<Map<String, dynamic>> _transactions = [];

  int _selectedIndex = 1; // 0 = Home, 1 = Fee Status

  @override
  void initState() {
    super.initState();
    _monthlyFee = 3200.0;
    _dueAmount = _monthlyFee;

    final now = DateTime.now();
    _dueDate = DateTime(now.year, now.month, 5);
  }

  bool get _isLate => DateTime.now().isAfter(_dueDate) && _dueAmount > 0;

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudentHome()),
      );
    }
  }

  Future<void> _payNow() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Processing payment...')),
    );

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _transactions.insert(0, {
        'date': DateTime.now().toString().split(' ')[0],
        'amount': _dueAmount,
        'type': 'Credit',
      });
      _dueAmount = 0.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment successful')),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fee Status'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Due Amount Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.blue,
                ),
                title: const Text(
                  'Due Amount',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('₹${_dueAmount.toStringAsFixed(2)}'),
                    const SizedBox(height: 4),
                    Text(
                      'Due Date: ${_formatDate(_dueDate)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: _dueAmount > 0 ? _payNow : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 225, 228, 232),
                  ),
                  child: Text(_dueAmount > 0 ? 'Pay Now' : 'Paid'),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Late fee warning
            if (_dueAmount > 0 && _isLate)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Late fee may apply! Please pay immediately.',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (_dueAmount > 0 && _isLate) const SizedBox(height: 12),

            // Transactions title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Transactions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),

            // Transactions list
            Expanded(
              child: _transactions.isEmpty
                  ? const Center(child: Text('No transactions yet'))
                  : ListView.builder(
                      itemCount: _transactions.length,
                      itemBuilder: (_, i) {
                        final t = _transactions[i];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: Icon(
                              Icons.arrow_downward,
                              color: Colors.green,
                            ),
                            title: Text(
                              '₹${t['amount']} • ${t['type']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(t['date']),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // 🔽 Bottom Navigation (ONLY 2 ITEMS)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: "Fee Status",
          ),
        ],
      ),
    );
  }
}
