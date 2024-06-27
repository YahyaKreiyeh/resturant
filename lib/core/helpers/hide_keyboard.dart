import 'package:flutter/material.dart';
import 'package:resturant/core/utils/device/device_utility.dart';

class HideKeyboard extends StatelessWidget {
  final Widget child;

  const HideKeyboard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => DeviceUtility.hideKeyboard(context),
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}
