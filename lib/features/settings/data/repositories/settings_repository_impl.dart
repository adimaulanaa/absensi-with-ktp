import 'package:attendance_ktp/core/error/failures.dart';
import 'package:attendance_ktp/features/dashboard/data/models/employee_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/response_model.dart';
import 'package:attendance_ktp/features/settings/data/datasources/settings_local_source.dart';
import 'package:attendance_ktp/features/settings/data/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalSource dataLocalSource;

  SettingsRepositoryImpl({required this.dataLocalSource});

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
  Future<Either<Failure, ResponseModel>> deleteEmployeeId(String id) async {
    try {
      final result = await dataLocalSource.deleteEmployeeId(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ResponseModel>> createEmployee(EmployeeModel dt) async {
    try {
      final result = await dataLocalSource.createEmployee(dt);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
