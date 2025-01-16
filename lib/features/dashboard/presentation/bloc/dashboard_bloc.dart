import 'package:attendance_ktp/core/error/failures.dart';
import 'package:attendance_ktp/features/dashboard/data/models/absensi_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/dashboard_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/employee_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/response_model.dart';
import 'package:attendance_ktp/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart'; // Tambahkan import dartz
import 'bloc.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _dashboardRepo;

  DashboardBloc({required DashboardRepository dashboardRepo})
      : _dashboardRepo = dashboardRepo,
        super(DashboardInitial()) {
    on<GetDashboard>(_onDashboard);
    on<GetEmployee>(_onEmployee);
    on<GetAbsensi>(_onAbsensi);
    on<CreateAbsensi>(_onCreateAbsensi);
  }

  void _onDashboard(GetDashboard event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());

    final Either<Failure, List<DashboardModel>> result =
        await _dashboardRepo.dashboard();
    result.fold(
      (failure) => emit(DashboardError(mapFailureToMessage(failure))),
      (success) => emit(DashboardLoaded(success)),
    );
  }

  void _onEmployee(GetEmployee event, Emitter<DashboardState> emit) async {
    emit(EmployeeLoading());

    final Either<Failure, List<EmployeeModel>> result =
        await _dashboardRepo.employee();
    result.fold(
      (failure) => emit(EmployeeError(mapFailureToMessage(failure))),
      (success) => emit(EmployeeLoaded(success)),
    );
  }

  void _onAbsensi(GetAbsensi event, Emitter<DashboardState> emit) async {
    emit(AbsensiLoading());

    final Either<Failure, List<AbsensiModel>> result =
        await _dashboardRepo.absensi();
    result.fold(
      (failure) => emit(AbsensiError(mapFailureToMessage(failure))),
      (success) => emit(AbsensiLoaded(success)),
    );
  }

  void _onCreateAbsensi(
      CreateAbsensi event, Emitter<DashboardState> emit) async {
    emit(CreateAbsensiLoading());

    final Either<Failure, ResponseModel> result =
        await _dashboardRepo.createAbsensi(event.create);
    result.fold(
      (failure) => emit(CreateAbsensiError(mapFailureToMessage(failure))),
      (success) => emit(CreateAbsensiSuccess(success)),
    );
  }
}
