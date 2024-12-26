import 'package:attendance_ktp/core/config/config_resources.dart';
import 'package:attendance_ktp/features/data/database_service.dart';
import 'package:attendance_ktp/features/data/employee_provider.dart';
import 'package:attendance_ktp/features/data/employee_service.dart';
import 'package:attendance_ktp/features/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  // Inisialisasi databaseService
  final database = DatabaseService();
  final prefs = await SharedPreferences.getInstance();
  // runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => EmployeeProvider(
            emplyeeService: EmployeeService(),
            prefs: prefs,
            database: database,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Josefin Sans', // Mengatur font default untuk aplikasi
      ),
      title: StringResources.nameApp,
      initialRoute: '/onboarding',
      // getPages: AppPages.routes,
      // unknownRoute: AppPages.routes.first,
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      routes: {
        '/onboarding': (context) => const Onboarding(),
        // Definisikan rute lain di sini jika diperlukan
      },
    );
  }
}