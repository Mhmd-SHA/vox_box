import 'package:flutter/material.dart';

import '../../const/app_colors/app_colors.dart';

class AppButton extends StatelessWidget {
  AppButton({Key? key, required this.onPress, required this.buttonText})
      : super(key: key);
  Function() onPress;

  String buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
      ),
      onPressed: onPress,
      child: Center(
        child: Text(
          buttonText,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
