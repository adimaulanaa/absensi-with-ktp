// File: lib/features/auth/data/repositories/auth_repository.dart

import 'package:attendance_ktp/core/error/failures.dart';
import 'package:attendance_ktp/features/dashboard/data/models/employee_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/response_model.dart';
import 'package:dartz/dartz.dart';

abstract class SettingsRepository {
  Future<Either<Failure, List<EmployeeModel>>> employee();
  Future<Either<Failure, ResponseModel>> deleteEmployeeId(String id);
  Future<Either<Failure, ResponseModel>> createEmployee(EmployeeModel dt);
}
