import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_basic/components/constants.dart';
import 'package:flutter_firebase_basic/components/custom_bottom_nav_bar.dart';
import 'package:flutter_firebase_basic/components/enums.dart';
import 'package:flutter_firebase_basic/screens/student/add_student.dart';
import 'package:flutter_firebase_basic/services/student.dart';

class HomeStudent extends StatefulWidget {
  static String routeName = '/student';
  final String classroomName;
  final String classroomId;
  const HomeStudent(
      {super.key, required this.classroomName, required this.classroomId});

  @override
  State<HomeStudent> createState() => _HomeStudentState();
}

class _HomeStudentState extends State<HomeStudent> {
  Stream? studentStream;

  getontheload() async {
    studentStream = await StudentMethods().getStudentDetail(widget.classroomId);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget getAllTeacher() {
    return StreamBuilder(
        stream: studentStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Tên: " + ds['Name'],
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        // nameController.text = ds['Name'];
                                        // ageController.text = ds['Age'];
                                        // locationController.text =
                                        //     ds['Location'];
                                        // editTeacher(ds['Id']);
                                      },
                                      child: const Icon(Icons.edit,
                                          color: Colors.orange)),
                                  const SizedBox(width: 5.0),
                                  GestureDetector(
                                      onTap: () {
                                        // deleteTeacher(ds['Id']);
                                      },
                                      child: const Icon(Icons.delete,
                                          color: Colors.red))
                                ],
                              ),
                              Text(
                                "Năm sinh: " + ds['Dob'],
                                style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Địa chỉ: " + ds['Address'],
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddStudent(
                        classroomId: widget.classroomId,
                        classroomName: widget.classroomName,
                      )));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DANH SÁCH SINH VIÊN ' + widget.classroomName,
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
        child: Column(
          children: [
            Container(
              width: 400,
              height: 50,
              decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                  onChanged: (value) {
                    // search value
                  },
                  decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Tìm kiếm...",
                      prefixIcon: Icon(Icons.search),
                      contentPadding:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0))),
            ),
            const SizedBox(height: 20.0),
            Expanded(child: getAllTeacher())
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        selectedMenu: MenuState.teacher,
      ),
    );
  }
}
