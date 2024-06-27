import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:resturant/core/utils/constants/colors.dart';

class AppElevatedButton extends StatelessWidget {
  final String text;
  const AppElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(70).r,
        ),
        minimumSize: Size(100.w, 56.h),
        side: BorderSide(
          width: 1.r,
          color: ColorsManager.black,
        ),
        padding: const EdgeInsets.all(14.6).r,
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
