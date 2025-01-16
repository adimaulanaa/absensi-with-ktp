import 'package:attendance_ktp/features/dashboard/data/models/absensi_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/dashboard_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/employee_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/response_model.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}
class EmployeeLoading extends DashboardState {}
class AbsensiLoading extends DashboardState {}
class CreateAbsensiLoading extends DashboardState {}

class DashboardError extends DashboardState {
  final String error;

  const DashboardError(this.error);

  @override
  List<Object> get props => [error];
}

class DashboardLoaded extends DashboardState {
  final List<DashboardModel> data;
  const DashboardLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class EmployeeError extends DashboardState {
  final String error;

  const EmployeeError(this.error);

  @override
  List<Object> get props => [error];
}

class EmployeeLoaded extends DashboardState {
  final List<EmployeeModel> data;
  const EmployeeLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class AbsensiError extends DashboardState {
  final String error;

  const AbsensiError(this.error);

  @override
  List<Object> get props => [error];
}

class AbsensiLoaded extends DashboardState {
  final List<AbsensiModel> data;
  const AbsensiLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class CreateAbsensiError extends DashboardState {
  final String error;

  const CreateAbsensiError(this.error);

  @override
  List<Object> get props => [error];
}

class CreateAbsensiSuccess extends DashboardState {
  final ResponseModel success;

  const CreateAbsensiSuccess(this.success);

  @override
  List<Object> get props => [success];
}