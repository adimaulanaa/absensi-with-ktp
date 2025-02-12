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
import 'package:intl/intl.dart';

class ViewAllEmployee extends StatefulWidget {
  const ViewAllEmployee({super.key});

  @override
  State<ViewAllEmployee> createState() => _ViewAllEmployeeState();
}

class _ViewAllEmployeeState extends State<ViewAllEmployee> {
  final searchController = TextEditingController();
  List<EmployeeModel> allEmployee = [];
  List<EmployeeModel> employee = [];

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const GetEmployee());
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
              employee = allEmployee;
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
            SizedBox(height: size.height * 0.01),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Kotak warna putih
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Bayangan bawah
                    ),
                  ],
                ),
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
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                    ),
                    filled: true,
                    fillColor: Colors.white, // Pastikan fillColor juga putih
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        MediaRes.dSearch,
                        // ignore: deprecated_member_use
                        color: AppColors.bgGrey,
                        width: 20,
                      ),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          searchController
                              .clear(); // Menghapus teks saat diklik
                        },
                        child: SvgPicture.asset(
                          MediaRes.dSearchRight,
                          // ignore: deprecated_member_use
                          color: AppColors.bgGrey,
                          width: 20,
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 14.0),
                  ),
                  onChanged: (value) {
                    search(value);
                  },
                  maxLines: 1,
                  style: blackTextstyle.copyWith(
                    fontSize: 16,
                    fontWeight: light,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: employee.map((e) {
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

  void search(String query) {
    final lowerCaseQuery = query.toLowerCase(); // Pencarian berdasarkan nama

    List<EmployeeModel> init = allEmployee;
    employee = [];
    setState(() {
      employee = init.where((e) {
        final applicantName = e.name!.toLowerCase(); // Nama pelamar

        // Pencocokan query dengan nama pelamar
        bool matchesQuery = applicantName.contains(lowerCaseQuery);

        return matchesQuery;
      }).toList();
    });
  }
}

Widget listEmployee(
  Size size,
  EmployeeModel e,
) {
  String formattedDate = DateFormat('dd MMMM yyyy').format(e.createdOn!);
  String formattedTime = DateFormat('HH:mm:ss').format(e.createdOn!);
  return Container(
    // height: size.height * 0.05,
    padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
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
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formattedDate,
              style: whiteTextstyle.copyWith(
                fontSize: 12,
                fontWeight: medium,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(width: 5),
            Text(
              formattedTime,
              style: whiteTextstyle.copyWith(
                fontSize: 12,
                fontWeight: medium,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ],
    ),
  );
}
