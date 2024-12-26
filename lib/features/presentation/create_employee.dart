import 'package:attendance_ktp/core/config/config_resources.dart';
import 'package:attendance_ktp/core/media/media_colors.dart';
import 'package:attendance_ktp/core/media/media_text.dart';
import 'package:attendance_ktp/core/utils/loading.dart';
import 'package:attendance_ktp/core/utils/snackbar_extension.dart';
import 'package:attendance_ktp/features/data/employee_provider.dart';
import 'package:attendance_ktp/features/model/employee_model.dart';
import 'package:attendance_ktp/features/model/response_model.dart';
import 'package:attendance_ktp/features/presentation/setting_screen.dart';
import 'package:attendance_ktp/features/widgets/reading_nfc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:provider/provider.dart';

class CreateEmployee extends StatefulWidget {
  const CreateEmployee({super.key});

  @override
  State<CreateEmployee> createState() => _CreateEmployeeState();
}

class _CreateEmployeeState extends State<CreateEmployee> {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  ResponseModel response = ResponseModel();
  final idController = TextEditingController();
  final nameController = TextEditingController();
  bool isId = false;
  bool isListening = false;
  String sak = '';
  String standart = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading.value
          ? const UIDialogLoading(text: StringResources.loading)
          : _bodyData(context, size),
      floatingActionButton: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        onTap: () {
          if (idController.text.isNotEmpty && nameController.text.isNotEmpty) {
            isLoading.value = true;
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
      ),
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
                  // getIDKtp();
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
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getIDKtp() async {
    setState(() {
      isListening = !isListening;
    });

    if (isListening) {
      var availability = await FlutterNfcKit.nfcAvailability;
      if (availability == NFCAvailability.available) {
        while (isListening) {
          try {
            final NFCTag tag = await FlutterNfcKit.poll();
            setState(() {
              idController.text = tag.id;
              sak = tag.sak ?? '';
              standart = tag.standard;
              Navigator.pop(context);
            });
          } on Exception catch (e) {
            setState(() {
              // ignore: avoid_print
              print('Error reading NFC: $e');
              isListening = false;
            });
          }
        }
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        FlutterNfcKit.finish();
      }
    } else {
      // If the user wants to stop listening
      Navigator.pop(context);
      FlutterNfcKit.finish();
    }
  }

  void seveData() async {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    EmployeeModel push = EmployeeModel(
      id: idController.text,
      name: nameController.text,
      sak: sak,
      standard: standart,
      createdOn: DateTime.now(),
      updatedOn: DateTime.now(),
    );
    response = await provider.createEmployee(push);
    if (response.isSucces) {
      // ignore: use_build_context_synchronously
      context.showSuccesSnackBar(
        response.message,
        onNavigate: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SettingScreen(),
            ),
          );
        }, // bottom close
      );
    } else {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(
        response.message,
        onNavigate: () {}, // bottom close
      );
    }
  }
}
