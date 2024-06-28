import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:vox_box/const/app_colors/app_colors.dart';

class LoginButton extends StatelessWidget {
  LoginButton({
    Key? key,
    required this.onPress,
    required this.buttonText,
  }) : super(key: key);
  Function() onPress;

  String buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Image.asset(
        "assets/Google.png",
        width: 35,
        height: 35,
      ),
      onPressed: onPress,
      label: Text(
        buttonText,
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
      ),
    );
  }
}
