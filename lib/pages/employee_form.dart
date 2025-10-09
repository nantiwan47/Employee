import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/employee_service.dart';

class EmployeeFormPage extends StatefulWidget {
  final Employee? employee;

  const EmployeeFormPage({super.key, this.employee});

  @override
  State<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = EmployeeService();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneController = TextEditingController();

  bool get isEdit => widget.employee != null;

  final List<String> _genderOptions = ["Male", "Female", "Other"];

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _firstNameController.text = widget.employee!.firstName;
      _lastNameController.text = widget.employee!.lastName;
      _emailController.text = widget.employee!.email;
      _genderController.text = widget.employee!.gender;
      _phoneController.text = widget.employee!.phone;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    final newEmp = Employee(
      id: isEdit ? widget.employee!.id : '',
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      gender: _genderController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    try {
      if (isEdit) {
        await _service.updateEmployee(newEmp);
      } else {
        await _service.addEmployee(newEmp);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEdit ? "Employee updated" : "Employee added"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "แก้ไขพนักงาน" : "เพิ่มพนักงาน")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildField(_firstNameController, "First Name", Icons.person),
                const SizedBox(height: 12),
                _buildField(_lastNameController, "Last Name", Icons.person_outline,),
                const SizedBox(height: 12),
                _buildField(_emailController, "Email", Icons.email, keyboard: TextInputType.emailAddress, validator: (v) => v!.contains('@') ? null : "Invalid email",),
                const SizedBox(height: 12),
                _buildPhoneField(_phoneController, "Phone", Icons.phone),
                const SizedBox(height: 12),
                _buildDropdownField(_genderController, "Gender", Icons.wc, _genderOptions),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveEmployee,
                    icon: const Icon(Icons.save),
                    label: Text(isEdit ? "Update" : "Save"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function สำหรับ TextFormField
  Widget _buildField(
    TextEditingController c,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: c,
      keyboardType: keyboard,
      validator: validator ?? (v) => v!.isEmpty ? "Required" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildPhoneField(
    TextEditingController c,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: c,
      keyboardType: TextInputType.phone,
      maxLength: 10, // กำหนดไม่เกิน 10 หลัก
      validator: (v) {
        if (v == null || v.isEmpty) return "Required";
        if (v.length > 10) return "Phone number cannot exceed 10 digits";
        if (!RegExp(r'^[0-9]+$').hasMatch(v)) return "Only digits allowed";
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        counterText: "", // ซ่อนตัวนับจำนวนอักขระ
      ),
    );
  }

  Widget _buildDropdownField(
    TextEditingController c,
    String label,
    IconData icon,
    List<String> options,
  ) {
    return DropdownButtonFormField<String>(
      value: c.text.isNotEmpty ? c.text : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: options
          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
          .toList(),
      onChanged: (val) => c.text = val ?? '',
      validator: (val) => val == null || val.isEmpty ? "Required" : null,
    );
  }
}
