import 'package:attendance_ktp/core/config/config_resources.dart';
import 'package:attendance_ktp/core/media/media_colors.dart';
import 'package:attendance_ktp/core/media/media_res.dart';
import 'package:attendance_ktp/core/media/media_text.dart';
import 'package:attendance_ktp/core/utils/loading.dart';
import 'package:attendance_ktp/core/utils/snackbar_extension.dart';
import 'package:attendance_ktp/features/dashboard/data/models/employee_model.dart';
import 'package:attendance_ktp/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:attendance_ktp/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:attendance_ktp/features/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ViewAllEmployee extends StatefulWidget {
  const ViewAllEmployee({super.key});

  @override
  State<ViewAllEmployee> createState() => _ViewAllEmployeeState();
}

class _ViewAllEmployeeState extends State<ViewAllEmployee> {
  final searchController = TextEditingController();
  List<EmployeeModel> allEmployee = [];

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const GetEmployee());
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
          'Employee',
          style: blackTextstyle.copyWith(
            fontSize: 20,
            fontWeight: bold,
          ),
        ),
        leading: InkWell(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.pop(context);
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
      // body: _bodyData(size),
      body: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is EmployeeError) {
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
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
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
    );
  }

  SafeArea _bodyData(BuildContext context, Size size) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.05),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search Note...',
                  hintStyle: greyTextstyle.copyWith(
                    fontSize: 16,
                    fontWeight: light,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.bgTrans,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: InputBorder.none,
                  filled: true,
                  fillColor: AppColors.bgColor,
                  // Menambahkan ikon di kiri
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      MediaRes.dSearch, // Ganti dengan ikon kiri yang sesuai
                      // ignore: deprecated_member_use
                      color: AppColors.bgGrey,
                      width: 20, // Sesuaikan ukuran ikon
                    ),
                  ),
                  // Ikon di kanan tetap ada
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        // searchController.text = '';
                        // search('');
                      },
                      child: SvgPicture.asset(
                        MediaRes.dSearchRight,
                        // ignore: deprecated_member_use
                        color: AppColors.bgGrey,
                        width: 20, // Sesuaikan ukuran ikon
                      ),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 14.0),
                ),
                onChanged: (value) {
                  // search(value);
                },
                maxLines: 1,
                style: blackTextstyle.copyWith(
                  fontSize: 16,
                  fontWeight: light,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: allEmployee.map((e) {
                    return listEmployee(size, e);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget listEmployee(
  Size size,
  EmployeeModel e,
) {
  return Container(
    height: size.height * 0.05,
    padding: const EdgeInsets.only(left: 20, right: 20),
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          e.id.toString(),
          style: whiteTextstyle.copyWith(
            fontSize: 12,
            fontWeight: medium,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(width: 5),
        Text(
          e.name.toString(),
          style: whiteTextstyle.copyWith(
            fontSize: 12,
            fontWeight: medium,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    ),
  );
}
