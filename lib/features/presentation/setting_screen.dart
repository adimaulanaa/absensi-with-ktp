import 'package:attendance_ktp/core/config/config_resources.dart';
import 'package:attendance_ktp/core/media/media_colors.dart';
import 'package:attendance_ktp/core/media/media_res.dart';
import 'package:attendance_ktp/core/media/media_text.dart';
import 'package:attendance_ktp/core/utils/loading.dart';
import 'package:attendance_ktp/core/utils/snackbar_extension.dart';
import 'package:attendance_ktp/features/data/employee_provider.dart';
import 'package:attendance_ktp/features/model/employee_model.dart';
import 'package:attendance_ktp/features/model/response_model.dart';
import 'package:attendance_ktp/features/presentation/create_employee.dart';
import 'package:attendance_ktp/features/presentation/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final ValueNotifier<bool> isLoading = ValueNotifier(true);
  final searchController = TextEditingController();
  List<EmployeeModel> allEmployee = [];
  List<EmployeeModel> viewEmployee = [];
  ResponseModel response = ResponseModel();
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgScreen,
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
      body: isLoading.value
          ? const UIDialogLoading(text: StringResources.loading)
          : _bodyData(context, size),
    );
  }

  SingleChildScrollView _bodyData(BuildContext context, Size size) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        builder: (context) => const CreateEmployee(),
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
              children: viewEmployee.map((e) {
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
                          isLoading.value = true;
                          deleteId(e.id.toString());
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
            )
          ],
        ),
      ),
    );
  }

  void _loadData() async {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    allEmployee = await provider.getEmployee();
    viewEmployee = allEmployee;
    isLoading.value = false;
    setState(() {});
  }

  void deleteId(String id) async {
    final provider = Provider.of<EmployeeProvider>(context, listen: false);
    response = await provider.deleteEmployee(id);
    isLoading.value = false;
    if (response.isSucces) {
      // ignore: use_build_context_synchronously
      context.showSuccesSnackBar(
        response.message,
        onNavigate: () {
          _loadData();
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
