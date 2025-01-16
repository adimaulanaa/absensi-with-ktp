import 'package:attendance_ktp/core/config/dio_config.dart';
import 'package:attendance_ktp/features/dashboard/data/datasources/dashboard_local_source.dart';
import 'package:attendance_ktp/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:attendance_ktp/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:attendance_ktp/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:attendance_ktp/features/services/database_service.dart';
import 'package:attendance_ktp/features/services/employee_db_service.dart';
import 'package:attendance_ktp/features/settings/data/datasources/settings_local_source.dart';
import 'package:attendance_ktp/features/settings/data/repositories/settings_repository.dart';
import 'package:attendance_ktp/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:attendance_ktp/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  final DatabaseService localDatabase = DatabaseService();
  final employeeDbService = EmployeeDbService();
  sl.registerLazySingleton(() => employeeDbService);
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => localDatabase);

  //! Core
  sl.registerLazySingleton<Dio>(() => createDio());

  //! Settings
  sl.registerLazySingleton<SettingsLocalSource>(
    () => SettingsLocalSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
      employeeDbService: sl<EmployeeDbService>(),
    ),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(dataLocalSource: sl<SettingsLocalSource>()),
  );
  sl.registerFactory(
      () => SettingsBloc(settingsRepo: sl<SettingsRepository>()));

  //! Dashboard
  sl.registerLazySingleton<DashboardLocalSource>(
    () => DashboardLocalSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
      employeeDbService: sl<EmployeeDbService>(),
    ),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(dataLocalSource: sl<DashboardLocalSource>()),
  );
  sl.registerFactory(
      () => DashboardBloc(dashboardRepo: sl<DashboardRepository>()));
}
