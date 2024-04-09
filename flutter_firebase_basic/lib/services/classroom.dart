import 'package:cloud_firestore/cloud_firestore.dart';

class ClassroomMethods {
  Future addClassroom(Map<String, dynamic> classroomMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Classroom')
        .doc(id)
        .set(classroomMap);
  }

  Future<Stream<QuerySnapshot>> getClassroomDetail() async {
    return FirebaseFirestore.instance.collection('Classroom').snapshots();
  }

  Future updateClassroom(String id, Map<String, dynamic> updateInfor) async {
    return await FirebaseFirestore.instance
        .collection('Classroom')
        .doc(id)
        .update(updateInfor);
  }

  Future deleteClassroom(String id) async {
    return await FirebaseFirestore.instance
        .collection('Classroom')
        .doc(id)
        .delete();
  }

  Stream<QuerySnapshot> getTeacherName(String idTeacher) {
    return FirebaseFirestore.instance.collection('Teacher').snapshots();
  }
}
