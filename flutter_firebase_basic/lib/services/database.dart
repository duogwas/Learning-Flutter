import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addEmployeeDetails(
      Map<String, dynamic> employeeInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Employee')
        .doc(id)
        .set(employeeInfoMap);
  }

  Future<Stream<QuerySnapshot>> getEmployeeDetails() async {
    return await FirebaseFirestore.instance.collection('Employee').snapshots();
  }

  Future updateEmployeeDetail(
      String id, Map<String, dynamic> updateInfor) async {
    return await FirebaseFirestore.instance
        .collection('Employee')
        .doc(id)
        .update(updateInfor);
  }

   Future deleteEmployeeDetail(
      String id) async {
    return await FirebaseFirestore.instance
        .collection('Employee')
        .doc(id)
        .delete();
  }
}
