import 'package:attendance_ktp/core/config/config_resources.dart';
import 'package:attendance_ktp/core/media/media_colors.dart';
import 'package:attendance_ktp/core/media/media_res.dart';
import 'package:attendance_ktp/core/media/media_text.dart';
import 'package:attendance_ktp/core/utils/loading.dart';
import 'package:attendance_ktp/core/utils/snackbar_extension.dart';
import 'package:attendance_ktp/features/dashboard/data/models/employee_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/response_model.dart';
import 'package:attendance_ktp/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:attendance_ktp/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:attendance_ktp/features/settings/presentation/bloc/settings_event.dart';
import 'package:attendance_ktp/features/settings/presentation/bloc/settings_state.dart';
import 'package:attendance_ktp/features/settings/presentation/pages/create_employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final searchController = TextEditingController();
  List<EmployeeModel> allEmployee = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() {
    allEmployee = [];
    context.read<SettingsBloc>().add(const GetEmployee());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgGreySecond,
      appBar: AppBar(
        backgroundColor: AppColors.bgScreen,
        centerTitle: true,
        title: Text(
          'Setting',
          style: blackTextstyle.copyWith(
            fontSize: 20,
            fontWeight: bold,
          ),
        ),
        leading: InkWell(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: SvgPicture.asset(
              MediaRes.back,
              // ignore: deprecated_member_use
              color: AppColors.bgBlack,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is EmployeeError) {
            if (state.error != '') {
              context.showErrorSnackBar(
                state.error,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is DeleteEmployeeIdError) {
            if (state.error != '') {
              context.showErrorSnackBar(
                state.error,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is EmployeeLoaded) {
            if (state.data.isNotEmpty) {
              allEmployee = state.data;
            }
          } else if (state is DeleteEmployeeIdSuccess) {
            checkSubmit(state.success);
          }
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return Stack(
              children: [
                _bodyData(context, size), // Latar belakang utama
                if (state is EmployeeLoading ||
                    state is DeleteEmployeeIdLoading) ...[
                  // Layar semi-transparan gelap
                  Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  // Loading overlay
                  const UIDialogLoading(text: StringResources.loading),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  SafeArea _bodyData(BuildContext context, Size size) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(),
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateEmployeeScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          MediaRes.addUser,
                          // ignore: deprecated_member_use
                          color: AppColors.bgBlack,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            'Employee',
                            style: blackTextstyle.copyWith(
                              fontSize: 15,
                              fontWeight: bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Column(
                children: allEmployee.map((e) {
                  return Container(
                    width: size.width,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Id ',
                                style: blackTextstyle.copyWith(
                                  fontSize: 13,
                                  fontWeight: medium,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                e.id.toString(),
                                style: blackTextstyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: medium,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Nama ',
                                style: blackTextstyle.copyWith(
                                  fontSize: 13,
                                  fontWeight: medium,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                e.name.toString(),
                                style: blackTextstyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: medium,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        InkWell(
                          splashFactory: NoSplash.splashFactory,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            context
                                .read<SettingsBloc>()
                                .add(DeleteEmployeeId(id: e.id.toString()));
                          },
                          child: SvgPicture.asset(
                            MediaRes.deleteUser,
                            fit: BoxFit.contain,
                            width: 20,
                            // ignore: deprecated_member_use
                            color: AppColors.bgBlack,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkSubmit(ResponseModel success) {
    if (success.isSucces) {
      load();
      context.showSuccesSnackBar(
        success.message,
        onNavigate: () {}, // bottom close
      );
    } else {
      context.showErrorSnackBar(
        success.message,
        onNavigate: () {}, // bottom close
      );
    }
    setState(() {});
  }
}
