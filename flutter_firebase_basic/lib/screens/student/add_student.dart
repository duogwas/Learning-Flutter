import 'package:flutter/material.dart';
import 'package:flutter_firebase_basic/screens/student/home_student.dart';
import 'package:flutter_firebase_basic/services/student.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class AddStudent extends StatefulWidget {
  final String classroomName;
  final String classroomId;

  const AddStudent(
      {super.key, required this.classroomName, required this.classroomId});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'THÔNG TIN SINH VIÊN',
              style: TextStyle(
                  color: Colors.blue,
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
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Năm sinh',
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
                    hintText: '10-04-2001',
                  ),
                  readOnly: true,
                  onTap: () {
                    _selectDate();
                  },
                )),
            const SizedBox(height: 20.0),
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
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    String id = randomAlphaNumeric(10);
                    Map<String, dynamic> studentInfoMap = {
                      'Id': id,
                      'Name': nameController.text,
                      'Dob': dobController.text,
                      'Address': addressController.text,
                      'Class_Id': widget.classroomId
                    };
                    try {
                      await StudentMethods().AddStudent(studentInfoMap, id);
                      Fluttertoast.showToast(
                          msg: "Thêm thành công",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeStudent(
                              classroomId: widget.classroomId,
                              classroomName: widget.classroomName,
                            ),
                          ));
                    } catch (e) {
                      Fluttertoast.showToast(
                          msg: "Thêm thất bại",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeStudent(
                              classroomId: widget.classroomId,
                              classroomName: widget.classroomName,
                            ),
                          ));
                    }
                  },
                  child: const Text('Thêm sinh viên',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold))),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_picked != null) {
      setState(() {
        dobController.text = DateFormat('dd-MM-yyyy').format(_picked);
        // dobController.text = _picked.toString().split(" ")[0];
      });
    }
  }
}
