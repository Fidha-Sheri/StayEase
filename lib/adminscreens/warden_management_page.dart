import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../admin_home.dart';
import 'profile_page.dart';

class WardenManagementPage extends StatefulWidget {
  const WardenManagementPage({super.key});

  @override
  State<WardenManagementPage> createState() => _WardenManagementPageState();
}

class _WardenManagementPageState extends State<WardenManagementPage> {

  int _selectedIndex = 1;

  void _onNavTap(int index){

    if(index==0){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminHome()),
      );
    }

    if(index==2){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    }
  }

  Future<void> deleteWarden(String id) async{
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .delete();
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

      body: StreamBuilder(

        stream: FirebaseFirestore.instance
            .collection("users")
            .where("role", isEqualTo: "warden")
            .snapshots(),

        builder: (context, snapshot){

          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator());
          }

          var wardens = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(

              columns: const [

                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Email")),
                DataColumn(label: Text("Delete")),

              ],

              rows: wardens.map((doc){

                return DataRow(

                  cells: [

                    DataCell(Text(doc['name'])),

                    DataCell(Text(doc['email'])),

                    DataCell(

                      IconButton(

                        icon: const Icon(Icons.delete,color: Colors.red),

                        onPressed: (){
                          deleteWarden(doc.id);
                        },
                      ),

                    )

                  ],
                );

              }).toList(),
            ),
          );

        },
      ),

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _selectedIndex,
        onTap: _onNavTap,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Wardens",
          ),

        ],
      ),
    );
  }
}