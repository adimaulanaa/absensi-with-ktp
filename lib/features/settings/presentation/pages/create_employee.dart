import 'package:attendance_ktp/core/config/config_resources.dart';
import 'package:attendance_ktp/core/media/media_colors.dart';
import 'package:attendance_ktp/core/media/media_text.dart';
import 'package:attendance_ktp/core/utils/loading.dart';
import 'package:attendance_ktp/core/utils/snackbar_extension.dart';
import 'package:attendance_ktp/features/dashboard/data/models/employee_model.dart';
import 'package:attendance_ktp/features/dashboard/data/models/response_model.dart';
import 'package:attendance_ktp/features/dashboard/presentation/widgets/reading_nfc.dart';
import 'package:attendance_ktp/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:attendance_ktp/features/settings/presentation/bloc/settings_event.dart';
import 'package:attendance_ktp/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class CreateEmployeeScreen extends StatefulWidget {
  const CreateEmployeeScreen({super.key});

  @override
  State<CreateEmployeeScreen> createState() => _CreateEmployeeScreenState();
}

class _CreateEmployeeScreenState extends State<CreateEmployeeScreen> {
  final idController = TextEditingController();
  final nameController = TextEditingController();
  String sak = '';
  String standart = '';
  bool isSubmit = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is CreateEmployeeError) {
            if (state.error != '') {
              context.showErrorSnackBar(
                state.error,
                onNavigate: () {}, // bottom close
              );
            }
          } else if (state is CreateEmployeeSuccess) {
            checkSubmit(state.success);
          }
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return Stack(
              children: [
                _bodyData(context, size), // Latar belakang utama
                if (state is EmployeeLoading) ...[
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
      floatingActionButton: isSubmit
          ? InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                if (idController.text.isNotEmpty &&
                    nameController.text.isNotEmpty) {
                  seveData();
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 32,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Simpan',
                    style: whiteTextstyle.copyWith(
                      fontSize: 22,
                      fontWeight: medium,
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  SafeArea _bodyData(BuildContext context, Size size) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Create',
                  style: blackTextstyle.copyWith(
                    fontSize: 15,
                    fontWeight: bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                splashFactory: NoSplash.splashFactory,
                highlightColor: Colors.transparent,
                onTap: () {
                  readingNFC(
                    context,
                    size,
                    () {
                      getIDKtp();
                    },
                    () {
                      FlutterNfcKit.finish();
                    },
                  );
                },
                child: Container(
                  // width: size.width * 0.25,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary,
                  ),
                  child: Center(
                    child: Text(
                      'NFC KTP',
                      style: whiteTextstyle.copyWith(
                        fontSize: 19,
                        fontWeight: bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: idController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Id',
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 13.0),
                  hintStyle: transTextstyle.copyWith(
                    fontSize: 15,
                    color: AppColors.bgGrey,
                    fontWeight: semiBold,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.tertiary,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: blackTextstyle.copyWith(
                  fontSize: 15,
                  fontWeight: semiBold,
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Nama',
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 13.0),
                  hintStyle: transTextstyle.copyWith(
                    fontSize: 15,
                    color: AppColors.bgGrey,
                    fontWeight: semiBold,
                  ),
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.tertiary,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                style: blackTextstyle.copyWith(
                  fontSize: 15,
                  fontWeight: semiBold,
                ),
                onChanged: (value) {
                  if (value != '') {
                    isSubmit = true;
                  }
                },
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getIDKtp() async {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability == NFCAvailability.available) {
      final NFCTag tag = await FlutterNfcKit.poll();
      idController.text = tag.id;
      sak = tag.sak ?? '';
      standart = tag.standard;
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      setState(() {});
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      FlutterNfcKit.finish();
    }
  }

  void seveData() async {
    EmployeeModel push = EmployeeModel(
      id: idController.text,
      name: nameController.text,
      sak: sak,
      standard: standart,
      createdOn: DateTime.now(),
      updatedOn: DateTime.now(),
    );
    context.read<SettingsBloc>().add(CreateEmployee(create: push));
  }

  void checkSubmit(ResponseModel success) {
    if (success.isSucces) {
      context.showSuccesSnackBar(
        success.message,
        onNavigate: () {
          context.read<SettingsBloc>().add(const GetEmployee());
          Navigator.pop(context);
        }, // bottom close
      );
    } else {
      context.showErrorSnackBar(
        success.message,
        onNavigate: () {}, // bottom close
      );
    }
  }
}
