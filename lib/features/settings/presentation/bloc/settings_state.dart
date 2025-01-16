import 'package:attendance_ktp/features/dashboard/data/models/employee_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/response_model.dart';
import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class EmployeeLoading extends SettingsState {}
class DeleteEmployeeIdLoading extends SettingsState {}
class CreateEmployeeLoading extends SettingsState {}

class EmployeeError extends SettingsState {
  final String error;

  const EmployeeError(this.error);

  @override
  List<Object> get props => [error];
}

class EmployeeLoaded extends SettingsState {
  final List<EmployeeModel> data;
  const EmployeeLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class DeleteEmployeeIdError extends SettingsState {
  final String error;

  const DeleteEmployeeIdError(this.error);

  @override
  List<Object> get props => [error];
}

class DeleteEmployeeIdSuccess extends SettingsState {
  final ResponseModel success;

  const DeleteEmployeeIdSuccess(this.success);

  @override
  List<Object> get props => [success];
}

class CreateEmployeeError extends SettingsState {
  final String error;

  const CreateEmployeeError(this.error);

  @override
  List<Object> get props => [error];
}

class CreateEmployeeSuccess extends SettingsState {
  final ResponseModel success;

  const CreateEmployeeSuccess(this.success);

  @override
  List<Object> get props => [success];
}