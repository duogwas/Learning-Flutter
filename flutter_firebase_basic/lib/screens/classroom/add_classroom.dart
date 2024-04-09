import 'package:flutter/material.dart';
import 'package:flutter_firebase_basic/screens/classroom/home_classroom.dart';
import 'package:flutter_firebase_basic/services/classroom.dart';
import 'package:flutter_firebase_basic/services/teacher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class AddClassroom extends StatefulWidget {
  const AddClassroom({super.key});

  @override
  State<AddClassroom> createState() => _AddClassroomState();
}

class _AddClassroomState extends State<AddClassroom> {
  TextEditingController classnameController =  TextEditingController();
  String? selectedValue;
  Stream? teacherStream;

  getontheload() async {
    teacherStream = await TeacherMethods().getTeacherDetail();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget listEmployee() {
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
              for (var employee in selectTeacher) {
                teacherItems.add(
                  DropdownMenuItem(
                    value: employee.id,
                    child: Text(
                      employee['Name'],
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
                  Fluttertoast.showToast(
                          msg: value,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                });
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'THÔNG TIN LỚP HỌC',
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, top: 30.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Giáo viên',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Container(
              child: listEmployee(),
            ),
            const SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    String id = randomAlphaNumeric(10);
                    Map<String, dynamic> classroomMap = {
                      'Id': id,
                      'Name': classnameController.text,
                      'Teacher_Id': selectedValue,
                    };
                    try {
                      await ClassroomMethods().addClassroom(classroomMap, id);
                      Fluttertoast.showToast(
                          msg: "Thêm lớp học thành công",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeClassroom()));
                    } catch (e) {
                      Fluttertoast.showToast(
                          msg: "Thêm lớp học thất bại",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeClassroom()));
                    }
                  },
                  child: const Text('THÊM',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold))),
            )
          ],
        ),
      ),
    );
  }
}
