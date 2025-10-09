import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee.dart';

class EmployeeService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('employee');

  // ดึงข้อมูลทั้งหมดแบบ real-time
  Stream<List<Employee>> getEmployeesStream() {
    return _collection.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => Employee.fromSnapshot(doc)).toList(),
    );
  }

  // เพิ่มข้อมูลใหม่
  Future<void> addEmployee(Employee employee) async {
    await _collection.add(employee.toMap());
  }

  // แก้ไขข้อมูล
  Future<void> updateEmployee(Employee employee) async {
    await _collection.doc(employee.id).update(employee.toMap());
  }

  // ลบข้อมูล
  Future<void> deleteEmployee(String id) async {
    await _collection.doc(id).delete();
  }
}
