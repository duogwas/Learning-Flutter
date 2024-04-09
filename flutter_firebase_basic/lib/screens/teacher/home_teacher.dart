import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_basic/screens/teacher/add_teacher.dart';
import 'package:flutter_firebase_basic/services/teacher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/custom_bottom_nav_bar.dart';
import '../../components/enums.dart';

class HomeTeacher extends StatefulWidget {
  static String routeName = '/teacher';

  const HomeTeacher({super.key});

  @override
  State<HomeTeacher> createState() => _HomeTeacherState();
}

class _HomeTeacherState extends State<HomeTeacher> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
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

  Widget getAllTeacher() {
    return StreamBuilder(
        stream: teacherStream,
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
                                        nameController.text = ds['Name'];
                                        ageController.text = ds['Age'];
                                        locationController.text =
                                            ds['Location'];
                                        editTeacher(ds['Id']);
                                      },
                                      child: const Icon(Icons.edit,
                                          color: Colors.orange)),
                                  const SizedBox(width: 5.0),
                                  GestureDetector(
                                      onTap: () {
                                        deleteTeacher(ds['Id']);
                                      },
                                      child: const Icon(Icons.delete,
                                          color: Colors.red))
                                ],
                              ),
                              Text(
                                "Năm sinh: " + ds['Age'],
                                style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Địa chỉ: " + ds['Location'],
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddTeacher()));
          },
          child: const Icon(Icons.add)),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'DANH SÁCH GIÁO VIÊN',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
          child: Column(
            children: [
              Expanded(child: getAllTeacher()),
            ],
          )),
      bottomNavigationBar: const CustomBottomNavBar(
        selectedMenu: MenuState.teacher,
      ),
    );
  }

  Future editTeacher(String id) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
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
                  const SizedBox(width: 25.0),
                  const Text(
                    "SỬA THÔNG TIN ",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 20.0),
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
                  controller: ageController,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
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
                  controller: locationController,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(height: 30.0),
              Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> updateInfor = {
                          'Id': id,
                          "Name": nameController.text,
                          "Age": ageController.text,
                          "Location": locationController.text
                        };
                        try {
                          await TeacherMethods().updateTeacher(id, updateInfor);
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
                              msg: "Cập nhật thất bại",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: const Text('Update')))
            ],
          )),
        ),
      );

  Future deleteTeacher(String id) => showDialog(
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
                'Bạn muốn xóa giáo viên này?',
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
                        await TeacherMethods().deleteTeacher(id);
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
                          minimumSize:  Size(100, 50),
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
