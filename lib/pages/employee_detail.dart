import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../models/employee.dart';
import 'employee_form.dart';
import '../utils/GenAndPrintPDF.dart';

class EmployeeDetailPage extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailPage({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${employee.firstName} ${employee.lastName}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.deepPurple[100],
                  child: Text(
                    employee.firstName[0].toUpperCase(),
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                _buildDetailRow("First Name", employee.firstName),
                const SizedBox(height: 12),
                _buildDetailRow("Last Name", employee.lastName),
                const SizedBox(height: 12),
                _buildDetailRow("Email", employee.email),
                const SizedBox(height: 12),
                _buildDetailRow("Phone", employee.phone),
                const SizedBox(height: 12),
                _buildDetailRow("Gender", employee.gender),
                // เพิ่มฟิลด์อื่น ๆ ได้ เช่น ตำแหน่ง, เบอร์โทร
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.edit),
            label: 'Edit',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EmployeeFormPage(employee: employee),
                ),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.picture_as_pdf),
            label: 'Export PDF',
            onTap: () async {
              await generateAndPrintPdf(employee); // ฟังก์ชัน export PDF ของคุณ
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF exported')),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget สำหรับแถวข้อมูล
  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
