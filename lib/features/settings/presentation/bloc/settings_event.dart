import 'package:attendance_ktp/features/dashboard/data/models/employee_model.dart';
import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class GetEmployee extends SettingsEvent {
  const GetEmployee();

  @override
  List<Object> get props => [];
}

class DeleteEmployeeId extends SettingsEvent {
  final String id;
  const DeleteEmployeeId({required this.id});

  @override
  List<Object> get props => [];
}

class CreateEmployee extends SettingsEvent {
  final EmployeeModel create;
  const CreateEmployee({required this.create});

  @override
  List<Object> get props => [];
}