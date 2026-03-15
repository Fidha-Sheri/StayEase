import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../admin_home.dart';
import 'profile_page.dart';

class StudentManagementPage extends StatefulWidget {
  const StudentManagementPage({super.key});

  @override
  State<StudentManagementPage> createState() => _StudentManagementPageState();
}

class _StudentManagementPageState extends State<StudentManagementPage> {

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

  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Student Management"),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),

      body: StreamBuilder(

        stream: FirebaseFirestore.instance
            .collection("users")
            .where("role", isEqualTo: "student")
            .snapshots(),

        builder: (context, snapshot){

          if(!snapshot.hasData){
            return const Center(child: CircularProgressIndicator());
          }

          var students = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(

              columns: const [

                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Email")),
                DataColumn(label: Text("Delete")),

              ],

              rows: students.map((doc){

                return DataRow(

                  cells: [

                    DataCell(Text(doc['name'])),

                    DataCell(Text(doc['email'])),

                    DataCell(

                      IconButton(

                        icon: const Icon(Icons.delete,color: Colors.red),

                        onPressed: (){

                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(doc.id)
                              .delete();

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

          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.group),label: "Students"),
         
        ],
      ),
    );
  }
}