import 'package:attendance_ktp/core/error/failures.dart';
import 'package:attendance_ktp/features/dashboard/data/datasources/dashboard_local_source.dart';
import 'package:attendance_ktp/features/dashboard/data/models/absensi_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/dashboard_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/employee_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/response_model.dart';
import 'package:attendance_ktp/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:dartz/dartz.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalSource dataLocalSource;

  DashboardRepositoryImpl({required this.dataLocalSource});

  @override
  Future<Either<Failure, List<DashboardModel>>> dashboard() async {
    try {
      final result = await dataLocalSource.dashboard();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EmployeeModel>>> employee() async {
    try {
      final result = await dataLocalSource.employee();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AbsensiModel>>> absensi()  async {
    try {
      final result = await dataLocalSource.absensi();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ResponseModel>> createAbsensi(AbsensiModel dt)  async {
    try {
      final result = await dataLocalSource.createAbsensi(dt);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
