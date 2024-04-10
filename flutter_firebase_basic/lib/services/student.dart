import 'package:cloud_firestore/cloud_firestore.dart';

class StudentMethods {
  Future AddStudent(Map<String, dynamic> studentMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Student')
        .doc(id)
        .set(studentMap);
  }

  Future<Stream<QuerySnapshot>> getStudentDetail(String idClass) async {
    return FirebaseFirestore.instance
        .collection('Student')
        .where('Class_Id', isEqualTo: idClass)
        .snapshots();
  }

  Future updateStudent(String id, Map<String, dynamic> updateInfor) async {
    return await FirebaseFirestore.instance
        .collection('Student')
        .doc(id)
        .update(updateInfor);
  }

  Future deleteStudent(String id) async {
    return await FirebaseFirestore.instance
        .collection('Student')
        .doc(id)
        .delete();
  }
}
