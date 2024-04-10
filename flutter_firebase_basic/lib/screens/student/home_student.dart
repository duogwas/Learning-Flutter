import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_basic/components/constants.dart';
import 'package:flutter_firebase_basic/components/custom_bottom_nav_bar.dart';
import 'package:flutter_firebase_basic/components/enums.dart';
import 'package:flutter_firebase_basic/screens/student/add_student.dart';
import 'package:flutter_firebase_basic/services/classroom.dart';
import 'package:flutter_firebase_basic/services/student.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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
  String? selectedValue;
  DateTime? selectedDated;
  Stream? classroomStream;
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  getontheload() async {
    studentStream = await StudentMethods().getStudentDetail(widget.classroomId);
    classroomStream = await ClassroomMethods().getClassroomDetail();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget getListClassroom(BuildContext context, StateSetter setState) {
    return StreamBuilder(
        stream: classroomStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          List<DropdownMenuItem> classroomItems = [];
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            final selectClassroom = snapshot.data?.docs.reversed.toList();
            if (selectClassroom != null) {
              for (var classroom in selectClassroom) {
                classroomItems.add(
                  DropdownMenuItem(
                    value: classroom.id,
                    child: Text(
                      classroom['Name'],
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
                "Chọn lớp",
                style: TextStyle(fontSize: 20),
              ),
              value: selectedValue,
              items: classroomItems,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
            ),
          );
        });
  }

  Widget getAllStudentInClass() {
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
                                        selectedValue = widget.classroomId;
                                        nameController.text = ds['Name'];
                                        addressController.text = ds['Address'];
                                        selectedDated = DateFormat("dd-MM-yyyy")
                                            .parse(ds['Dob']);
                                        dobController.text =
                                            DateFormat('dd-MM-yyyy')
                                                .format(selectedDated!);
                                        updateStudent(context, ds['Id']);
                                      },
                                      child: const Icon(Icons.edit,
                                          color: Colors.orange)),
                                  const SizedBox(width: 5.0),
                                  GestureDetector(
                                      onTap: () {
                                        deleteStudent(ds['Id']);
                                      },
                                      child: const Icon(Icons.delete,
                                          color: Colors.red))
                                ],
                              ),
                              Text(
                                "Ngày sinh: " + ds['Dob'],
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
            Expanded(child: getAllStudentInClass())
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        selectedMenu: MenuState.teacher,
      ),
    );
  }

  void updateStudent(BuildContext context, String id) {
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
                  const SizedBox(height: 15.0),
                  const Text(
                    'Họ và tên',
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
                      controller: nameController,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Ngày sinh',
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
                        controller: dobController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(top: 14.0),
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDate();
                        },
                      )),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Địa chỉ',
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
                      controller: addressController,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Lớp',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    child: getListClassroom(context, setState),
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            Map<String, dynamic> updateInfor = {
                              'Id': id,
                              "Name": nameController.text,
                              "Dob": dobController.text,
                              "Address": addressController.text,
                              "Class_Id": selectedValue,
                            };
                            try {
                              await StudentMethods()
                                  .updateStudent(id, updateInfor);
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

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: selectedDated,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_picked != null) {
      setState(() {
        dobController.text = DateFormat('dd-MM-yyyy').format(_picked);
      });
    }
  }

  Future deleteStudent(String id) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    "XÓA GIÁO VIÊN",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 40.0),
              const Text(
                'Bạn muốn xóa sinh viên này?',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30.0),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 50),
                        backgroundColor: Colors.redAccent),
                    onPressed: () async {
                      try {
                        await StudentMethods().deleteStudent(id);
                        Fluttertoast.showToast(
                            msg: "Xóa thành công",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pop(context);
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: "Xóa thất bại",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: const Text('XÓA',
                        style: TextStyle(color: Colors.white, fontSize: 18.0)),
                  ),
                  const SizedBox(width: 40.0),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(100, 50),
                          backgroundColor: Colors.grey),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('KHÔNG',
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.0))),
                ],
              ),
            ],
          )),
        ),
      );
}
