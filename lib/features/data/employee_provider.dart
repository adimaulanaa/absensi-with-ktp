import 'package:attendance_ktp/features/data/database_service.dart';
import 'package:attendance_ktp/features/data/employee_service.dart';
import 'package:attendance_ktp/features/model/absensi_model.dart';
import 'package:attendance_ktp/features/model/employee_model.dart';
import 'package:attendance_ktp/features/model/response_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeProvider extends ChangeNotifier {
  final EmployeeService emplyeeService;
  final SharedPreferences prefs;
  final DatabaseService database;

  EmployeeProvider({required this.emplyeeService, required this.prefs, required this.database});

  Future<List<EmployeeModel>> getEmployee() async {
    List<EmployeeModel> model = [];
    try {
      model = await database.getAllNote();
      notifyListeners();
      return model;
    } catch (e) {
      return model;
    }
  }

  Future<List<AbsensiModel>> getAbsensi() async {
    List<AbsensiModel> model = [];
    try {
      model = await database.getAllAbsensi();
      notifyListeners();
      return model;
    } catch (e) {
      return model;
    }
  }

  Future<EmployeeModel> getEmployeeId(String id) async {
    try {
      EmployeeModel model = await database.getNoteById(id);
      notifyListeners();
      return model;
    } catch (e) {
      return EmployeeModel();
    }
  }

  Future<ResponseModel> createEmployee(EmployeeModel note) async {
    try {
      ResponseModel create = await database.createEmployee(note);
      return create;
    } catch (e) {
      return ResponseModel(isSucces: false, message: e.toString());
    }
  }

  Future<ResponseModel> createAbsensi(AbsensiModel note) async {
    try {
      ResponseModel create = await database.createAbsensi(note);
      return create;
    } catch (e) {
      return ResponseModel(isSucces: false, message: e.toString());
    }
  }


  Future<ResponseModel> updateEmployee(EmployeeModel note) async {
    try {
      ResponseModel create = await database.createEmployee(note);
      return create;
    } catch (e) {
      return ResponseModel(isSucces: false, message: e.toString());
    }
  }

  Future<ResponseModel> deleteEmployee(String id) async {
    try {
      ResponseModel create = await database.deleteEmployee(id);
      return create;
    } catch (e) {
      return ResponseModel(isSucces: false, message: e.toString());
    }
  }
}
