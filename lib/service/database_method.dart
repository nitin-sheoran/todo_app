import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod {

  /// Create
  Future addTaskDetails(Map<String, dynamic> employeeInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Task")
        .doc(id)
        .set(employeeInfoMap);
  }

  /// Read
  Future<Stream<QuerySnapshot>> getTaskDetails() async {
    return FirebaseFirestore.instance.collection("Task").snapshots();
  }

  /// Update
  Future updateTaskDetails(String id, Map<String, dynamic> editInfo) async {
    return await FirebaseFirestore.instance
        .collection('Task')
        .doc(id)
        .update(editInfo);
  }

  /// Delete
  Future deleteTaskDetails(String id) async {
    return FirebaseFirestore.instance.collection('Task').doc(id).delete();
  }
}
