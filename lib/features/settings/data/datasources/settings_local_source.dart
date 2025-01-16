import 'package:attendance_ktp/features/dashboard/data/models/employee_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/response_model.dart';
import 'package:attendance_ktp/features/services/employee_db_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalSource {
  Future<List<EmployeeModel>> employee();
  Future<ResponseModel> deleteEmployeeId(String id);
  Future<ResponseModel> createEmployee(EmployeeModel dt);
}

class SettingsLocalSourceImpl implements SettingsLocalSource {
  final SharedPreferences sharedPreferences;
  final EmployeeDbService employeeDbService;

  SettingsLocalSourceImpl({
    required this.sharedPreferences,
    required this.employeeDbService,
  });

  @override
  Future<List<EmployeeModel>> employee() async {
    List<EmployeeModel> data = await employeeDbService.getAllEmployee();
    return data;
  }

  @override
  Future<ResponseModel> deleteEmployeeId(String id) async {
    ResponseModel data = await employeeDbService.deleteEmployee(id);
    return data;
  }
  
  @override
  Future<ResponseModel> createEmployee(EmployeeModel dt) async {
    ResponseModel data = await employeeDbService.createEmployee(dt);
    return data;
  }
}
