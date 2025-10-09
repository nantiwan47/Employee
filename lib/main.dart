import 'package:flutter/foundation.dart'; // สำหรับ kIsWeb
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/employee_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDYRSkL2i9qrghyijO5ltBZ8v_-L7SqcsE",
        authDomain: "demodbflutter-ead97.firebaseapp.com",
        projectId: "demodbflutter-ead97",
        storageBucket: "demodbflutter-ead97.firebasestorage.app",
        messagingSenderId: "496256783472",
        appId: "1:496256783472:web:fc59d89fb32d76a45f10b5",
        measurementId: "G-BEFV53KHVZ",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase CRUD',
      debugShowCheckedModeBanner: false,
      theme: _pastelTheme,
      home: EmployeeListPage(),
    );
  }
}

final ThemeData _pastelTheme = ThemeData(
  useMaterial3: true,

  // สีพื้นหลังหลักของแอป
  scaffoldBackgroundColor: const Color(0xFFFDF6EC),

  // โทนสีหลักของธีม (ใช้กับปุ่ม, highlight, slider, switch ฯลฯ)
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFFFC4A3), // สีพีชอ่อนเป็นสีหลักของธีม
    surface: const Color(0xFFFFF5E4),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black87,
  ),

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFC4A3),
    centerTitle: true,
    elevation: 3,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: Colors.white,
    ),
  ),

  // ปุ่ม Floating Action Button
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFFB6B6),
    foregroundColor: Colors.white,
    elevation: 3,
  ),

  // ปุ่ม ElevatedButton
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFC4A3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
    ),
  ),

  // ปุ่ม TextButton
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFFFF8E8E),
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
    ),
  ),

  // ปุ่ม IconButton
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(const Color(0xFF5C4033)),
    ),
  ),

  // Card (การ์ดพื้นหลัง)
  cardTheme: CardThemeData(
    color: const Color.fromARGB(255, 255, 255, 255),
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  ),

  // Input Field (TextField)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white, // สีพื้นขาวตลอดเวลา
    hoverColor: Colors.white, // ปิดสี hover
    focusColor: Colors.white, // ปิดสี focus
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    hintStyle: const TextStyle(color: Colors.black38),
  ),

  // SnackBar
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color.fromARGB(255, 255, 136, 136),
    contentTextStyle: TextStyle(color: Colors.white),
    behavior: SnackBarBehavior.fixed,
  ),

  // ListTile
  listTileTheme: const ListTileThemeData(
    textColor: Color(0xFF333333),
    titleTextStyle: TextStyle(fontWeight: FontWeight.w600),
    subtitleTextStyle: TextStyle(color: Colors.black54, height: 1.3),
  ),

  // ฟอนต์
  fontFamily: 'Kanit',
);
