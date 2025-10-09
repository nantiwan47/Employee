import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/employee.dart';

Future<void> generateAndPrintPdf(Employee emp) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Employee Detail', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Text('First Name: ${emp.firstName}'),
          pw.Text('Last Name: ${emp.lastName}'),
          pw.Text('Email: ${emp.email}'),
          pw.Text('Phone: ${emp.phone}'),
          pw.Text('Gender: ${emp.gender}'),
        ],
      ),
    ),
  );

  // แสดง dialog พิมพ์ / แชร์ PDF
  await Printing.layoutPdf(
    onLayout: (format) async => pdf.save(),
  );
}
