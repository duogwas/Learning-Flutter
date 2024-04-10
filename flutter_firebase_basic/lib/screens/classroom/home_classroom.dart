import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_basic/screens/classroom/add_classroom.dart';
import 'package:flutter_firebase_basic/screens/student/home_student.dart';
import 'package:flutter_firebase_basic/services/classroom.dart';
import 'package:flutter_firebase_basic/services/teacher.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../components/custom_bottom_nav_bar.dart';
import '../../components/enums.dart';

class HomeClassroom extends StatefulWidget {
  static String routeName = '/classroom';

  const HomeClassroom({super.key});

  @override
  State<HomeClassroom> createState() => _HomeClassroomState();
}

class _HomeClassroomState extends State<HomeClassroom> {
  TextEditingController classnameController = TextEditingController();
  Stream? classroomStream;
  String? selectedValue;
  Stream? teacherStream;

  getontheload() async {
    classroomStream = await ClassroomMethods().getClassroomDetail();
    teacherStream = await TeacherMethods().getTeacherDetail();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget getListTeacher(BuildContext context, StateSetter setState) {
    return StreamBuilder(
        stream: teacherStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          List<DropdownMenuItem> teacherItems = [];
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            final selectTeacher = snapshot.data?.docs.reversed.toList();
            if (selectTeacher != null) {
              for (var teacher in selectTeacher) {
                teacherItems.add(
                  DropdownMenuItem(
                    value: teacher.id,
                    child: Text(
                      teacher['Name'],
                    ),
                  ),
                );
              }
            }
          }
          return Container(
            padding: const EdgeInsets.only(right: 15, left: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton(
              underline: const SizedBox(),
              isExpanded: true,
              hint: const Text(
                "Chọn giáo viên",
                style: TextStyle(fontSize: 20),
              ),
              value: selectedValue,
              items: teacherItems,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
          );
        });
  }

  Widget getTeacherName(String id) {
    return StreamBuilder<QuerySnapshot>(
        stream: ClassroomMethods().getTeacherName(id),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            List<DocumentSnapshot> teacherDocs = snapshot.data!.docs;
            DocumentSnapshot teacherDoc =
                teacherDocs.firstWhere((doc) => doc.id == id);
            Map<String, dynamic> teacherData =
                teacherDoc.data() as Map<String, dynamic>;
            return Text(
              'Giáo viên: ${teacherData['Name']}',
              style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            );
          } else {
            return const Text('No teacher found with this ID');
          }
        });
  }

  Widget getListClassroom() {
    return StreamBuilder(
        stream: classroomStream,
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
                                    "Lớp: " + ds['Name'],
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeStudent(
                                              classroomName: ds['Name'],
                                              classroomId: ds['Id']),
                                        ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.add_box,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  GestureDetector(
                                      onTap: () {
                                        selectedValue = ds['Teacher_Id'];
                                        classnameController.text = ds['Name'];
                                        showDropdownDialog(context, ds['Id']);
                                      },
                                      child: const Icon(Icons.edit,
                                          color: Colors.orange)),
                                  const SizedBox(width: 5.0),
                                  GestureDetector(
                                      onTap: () {},
                                      child: const Icon(Icons.delete,
                                          color: Colors.red)),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              getTeacherName(ds['Teacher_Id']),
                              // Text(
                              //   "Giáo viên: " + ds['Teacher_Id'],
                              //   style: const TextStyle(
                              //       color: Colors.orange,
                              //       fontSize: 20.0,
                              //       fontWeight: FontWeight.bold),
                              // ),
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddClassroom()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DANH SÁCH LỚP HỌC',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
        child: Column(
          children: [Expanded(child: getListClassroom())],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        selectedMenu: MenuState.classroom,
      ),
    );
  }

  void showDropdownDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.cancel)),
                      const SizedBox(width: 24.0),
                      const Text(
                        "SỬA THÔNG TIN",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Tên lớp',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: classnameController,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Giáo viên',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    child: getListTeacher(context, setState),
                  ),
                  const SizedBox(height: 30.0),
                  Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            Map<String, dynamic> updateInfor = {
                              'Id': id,
                              "Name": classnameController.text,
                              "Teacher_Id": selectedValue,
                            };
                            try {
                              await ClassroomMethods()
                                  .updateClassroom(id, updateInfor);
                              Fluttertoast.showToast(
                                  msg: "Cập nhật thành công",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Navigator.pop(context);
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg: e.toString(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          child: const Text('Cập nhật')))
                ],
              )),
            );
          },
        );
      },
    );
  }
}
