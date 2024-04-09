import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherMethods {
  Future addTeacher(
      Map<String, dynamic> teacherInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(id)
        .set(teacherInfoMap);
  }

  Future<Stream<QuerySnapshot>> getTeacherDetail() async {
    return FirebaseFirestore.instance.collection('Teacher').snapshots();
  }
  
  Future updateTeacher(
      String id, Map<String, dynamic> updateInfor) async {
    return await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(id)
        .update(updateInfor);
  }

  Future deleteTeacher(String id) async {
    return await FirebaseFirestore.instance
        .collection('Teacher')
        .doc(id)
        .delete();
  }
}
