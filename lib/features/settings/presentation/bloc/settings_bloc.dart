import 'package:attendance_ktp/core/error/failures.dart';
import 'package:attendance_ktp/features/dashboard/data/models/employee_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/response_model.dart';
import 'package:attendance_ktp/features/settings/data/repositories/settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart'; // Tambahkan import dartz
import 'bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository _settingsRepo;

  SettingsBloc({required SettingsRepository settingsRepo})
      : _settingsRepo = settingsRepo,
        super(SettingsInitial()) {
    on<GetEmployee>(_onEmployee);
    on<DeleteEmployeeId>(_onDeleteEmployeeId);
    on<CreateEmployee>(_onCreateEmployee);
  }

  void _onEmployee(GetEmployee event, Emitter<SettingsState> emit) async {
    emit(EmployeeLoading());

    final Either<Failure, List<EmployeeModel>> result =
        await _settingsRepo.employee();
    result.fold(
      (failure) => emit(EmployeeError(mapFailureToMessage(failure))),
      (success) => emit(EmployeeLoaded(success)),
    );
  }

  void _onDeleteEmployeeId(
      DeleteEmployeeId event, Emitter<SettingsState> emit) async {
    emit(DeleteEmployeeIdLoading());

    final Either<Failure, ResponseModel> result =
        await _settingsRepo.deleteEmployeeId(event.id);
    result.fold(
      (failure) => emit(DeleteEmployeeIdError(mapFailureToMessage(failure))),
      (success) => emit(DeleteEmployeeIdSuccess(success)),
    );
  }

  void _onCreateEmployee(
      CreateEmployee event, Emitter<SettingsState> emit) async {
    emit(CreateEmployeeLoading());

    final Either<Failure, ResponseModel> result =
        await _settingsRepo.createEmployee(event.create);
    result.fold(
      (failure) => emit(CreateEmployeeError(mapFailureToMessage(failure))),
      (success) => emit(CreateEmployeeSuccess(success)),
    );
  }
}
