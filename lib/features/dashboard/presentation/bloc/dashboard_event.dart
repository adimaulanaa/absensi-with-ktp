import 'package:attendance_ktp/features/dashboard/data/models/absensi_model.dart';
import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class GetDashboard extends DashboardEvent {
  const GetDashboard();

  @override
  List<Object> get props => [];
}

class GetEmployee extends DashboardEvent {
  const GetEmployee();

  @override
  List<Object> get props => [];
}

class GetAbsensi extends DashboardEvent {
  const GetAbsensi();

  @override
  List<Object> get props => [];
}

class CreateAbsensi extends DashboardEvent {
  final AbsensiModel create;
  const CreateAbsensi({required this.create});

  @override
  List<Object> get props => [];
}
