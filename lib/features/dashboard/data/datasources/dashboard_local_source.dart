
import 'package:attendance_ktp/features/dashboard/data/models/absensi_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/dashboard_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/employee_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/response_model.dart';
import 'package:attendance_ktp/features/services/employee_db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DashboardLocalSource {
  Future<List<DashboardModel>> dashboard();
  Future<List<EmployeeModel>> employee();
  Future<List<AbsensiModel>> absensi();
  Future<ResponseModel> createAbsensi(AbsensiModel dt);
}

class DashboardLocalSourceImpl implements DashboardLocalSource {
  final SharedPreferences sharedPreferences;
  final EmployeeDbService employeeDbService;

  DashboardLocalSourceImpl({
    required this.sharedPreferences,
    required this.employeeDbService,
  });

  @override
  Future<List<DashboardModel>> dashboard() async {
    List<DashboardModel> data = [];
    return data;
  }
  
  @override
  Future<List<EmployeeModel>> employee() async {
    List<EmployeeModel> data = await employeeDbService.getTenEmployee();
    return data;
  }
  
  @override
  Future<List<AbsensiModel>> absensi() async {
    List<AbsensiModel> data = await employeeDbService.getAllAbsensi();
    return data;
  }
  
  @override
  Future<ResponseModel> createAbsensi(AbsensiModel dt) async {
    ResponseModel data = await employeeDbService.createAbsensi(dt);
    return data;
  }

}
