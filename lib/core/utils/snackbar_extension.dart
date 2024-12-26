import 'package:attendance_ktp/core/media/media_colors.dart';
import 'package:attendance_ktp/core/media/media_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum SnackBarStatus { success, error, info }

extension SnackBarExtension on BuildContext {
  /// Show a custom SnackBar with a specified message, status, and optional navigation callback.
  void showSuccesSnackBar(
    String message, {
    Duration duration = const Duration(milliseconds: 2500), // duration 3 second
    VoidCallback? onNavigate,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(this);

    // Show the SnackBar
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                message,
                style: whiteTextstyle.copyWith(
                  fontSize: 11,
                  fontWeight: medium,
                ),
              ),
            ),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
              child: Text(
                'Close',
                style: whiteTextstyle.copyWith(
                  fontSize: 11,
                  fontWeight: medium,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _getSnackBarColor(SnackBarStatus.success),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 50.0, left: 20.0, right: 20.0),
      ),
    );

    // Navigate or execute action after the specified duration
    Future.delayed(duration, () {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        onNavigate?.call();
      });
    });
  }

  void showErrorSnackBar(
    String message, {
    Duration duration = const Duration(milliseconds: 2500),
    VoidCallback? onNavigate,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(this);

    // Show the SnackBar
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                message,
                style: whiteTextstyle.copyWith(
                  fontSize: 11,
                  fontWeight: medium,
                ),
              ),
            ),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
              child: Text(
                'Close',
                style: whiteTextstyle.copyWith(
                  fontSize: 11,
                  fontWeight: medium,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _getSnackBarColor(SnackBarStatus.error),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 50.0, left: 20.0, right: 20.0),
      ),
    );

    // Navigate or execute action after the specified duration
    Future.delayed(duration, () {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        onNavigate?.call();
      });
    });
  }

  void showInfoSnackBar(
    String message, {
    Duration duration = const Duration(milliseconds: 2500),
    VoidCallback? onNavigate,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(this);

    // Show the SnackBar
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                message,
                style: whiteTextstyle.copyWith(
                  fontSize: 11,
                  fontWeight: medium,
                ),
              ),
            ),
            InkWell(
              splashFactory: NoSplash.splashFactory,
              highlightColor: Colors.transparent,
              onTap: () {
                scaffoldMessenger.hideCurrentSnackBar();
              },
              child: Text(
                'Close',
                style: whiteTextstyle.copyWith(
                  fontSize: 11,
                  fontWeight: medium,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _getSnackBarColor(SnackBarStatus.info),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 50.0, left: 20.0, right: 20.0),
      ),
    );

    // Navigate or execute action after the specified duration
    Future.delayed(duration, () {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        onNavigate?.call();
      });
    });
  }

  /// Private helper function to get the SnackBar background color based on status.
  Color _getSnackBarColor(SnackBarStatus status) {
    switch (status) {
      case SnackBarStatus.success:
        return AppColors.bgGreen;
      case SnackBarStatus.error:
        return Colors.red;
      case SnackBarStatus.info:
        return Colors.yellow;
      default:
        return Colors.black;
    }
  }
}
