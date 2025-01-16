// File: lib/features/auth/data/repositories/auth_repository.dart

import 'package:attendance_ktp/core/error/failures.dart';
import 'package:attendance_ktp/features/dashboard/data/models/absensi_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/dashboard_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/employee_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/response_model.dart';
import 'package:dartz/dartz.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<DashboardModel>>> dashboard();
  Future<Either<Failure, List<EmployeeModel>>> employee();
  Future<Either<Failure, List<AbsensiModel>>> absensi();
  Future<Either<Failure, ResponseModel>> createAbsensi(AbsensiModel dt);
}
