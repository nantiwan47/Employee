import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';
import 'employee_form.dart';
import 'employee_detail.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  // เรียกใช้งาน service ที่เชื่อมต่อกับฐานข้อมูล (CRUD)
  final EmployeeService _service = EmployeeService();

  // ตัวแปรสำหรับเก็บค่าคำค้นหา
  String _searchQuery = "";

  // ตัวกรองเพศ (ค่าเริ่มต้นคือ "All" )
  String _genderFilter = "All";

  // ฟังก์ชันลบพนักงาน พร้อมกล่องยืนยันก่อนลบ
  void _deleteEmployee(BuildContext context, Employee emp) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Delete ${emp.firstName} ${emp.lastName}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    // ถ้าผู้ใช้กดยืนยันให้ลบ
    if (confirm == true) {
      await _service.deleteEmployee(emp.id); // เรียกใช้ service เพื่อลบ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${emp.firstName} deleted successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ส่วนหัวของหน้า
      appBar: AppBar(
        title: const Text("รายชื่อพนักงาน"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildSearchField(), // กล่องค้นหา
                const SizedBox(height: 8),
                _buildGenderFilter(), // ปุ่มกรองเพศ
              ],
            ),
          ),
        ),
      ),

      // เนื้อหาหลักของหน้า (ใช้ StreamBuilder เพื่ออัปเดตข้อมูลแบบเรียลไทม์)
      body: StreamBuilder<List<Employee>>(
        stream: _service.getEmployeesStream(), // ดึงข้อมูลจาก Stream
        builder: (context, snapshot) {
          // ถ้ามี error ให้แสดงข้อความ
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // ถ้ายังโหลดข้อมูลไม่เสร็จ แสดงวงกลมโหลด
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // กรองข้อมูลตามคำค้นหาและเพศ
          final employees = snapshot.data!
              .where((emp) {
                final query = _searchQuery.toLowerCase();

                final matchesSearch = emp.firstName.toLowerCase().contains(query) ||
                    emp.lastName.toLowerCase().contains(query) ||
                    emp.email.toLowerCase().contains(query);

                final matchesGender = _genderFilter == "All" || emp.gender == _genderFilter;

                return matchesSearch && matchesGender;
              })
              .toList();

          // ถ้าไม่มีข้อมูลหลังกรอง
          if (employees.isEmpty) {
            return const Center(child: Text("ไม่พบพนักงาน"));
          }

          // แสดงรายชื่อพนักงานใน ListView
          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final emp = employees[index];

              return Slidable(
                key: ValueKey(emp.id),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    // ปุ่มแก้ไข
                    SlidableAction(
                      onPressed: (_) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EmployeeFormPage(employee: emp),
                          ),
                        );
                      },
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),

                    // ปุ่มลบ
                    SlidableAction(
                      onPressed: (_) => _deleteEmployee(context, emp),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),

                // การ์ดแสดงข้อมูลพนักงานแต่ละคน
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    // แสดงตัวอักษรตัวแรกของชื่อในวงกลม
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: Text(emp.firstName[0].toUpperCase()),
                    ),
                    title: Text("${emp.firstName} ${emp.lastName}"),
                    subtitle: Text("${emp.email}\nGender: ${emp.gender}"),
                    isThreeLine: true,

                    // เมื่อกดที่รายการ -> ไปหน้าแสดงรายละเอียด
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmployeeDetailPage(employee: emp),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),

      // ปุ่มเพิ่มพนักงานใหม่
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EmployeeFormPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  // ช่องค้นหาพนักงาน
  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'ค้นหาชื่อ, นามสกุล หรืออีเมล...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
      onChanged: (val) {
        setState(() {
          _searchQuery = val; // อัปเดตคำค้นหา
        });
      },
    );
  }

  // แถวปุ่มกรองเพศ
  Widget _buildGenderFilter() {
    final genders = ["All", "Male", "Female", "Other"];
    return Row(
      children: genders.map((g) {
        final selected = _genderFilter == g;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _genderFilter = g; // เปลี่ยนค่าตัวกรอง
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: selected ? const Color.fromARGB(255, 74, 164, 238) : Colors.grey[300],
                foregroundColor: selected ? Colors.white : Colors.black,
              ),
              child: Text(g),
            ),
          ),
        );
      }).toList(),
    );
  }
}
