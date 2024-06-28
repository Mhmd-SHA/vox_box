import 'package:flutter/material.dart';
import 'package:vox_box/const/app_colors/app_colors.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: AppColors.primaryColor,
  appBarTheme: AppBarTheme().copyWith(
    backgroundColor: AppColors.primaryColor,
    centerTitle: true,
    titleTextStyle: TextStyle().copyWith(
      color: AppColors.whiteColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  primaryColor: AppColors.primaryColor,
  colorScheme: ColorScheme.light().copyWith(
      outline: AppColors.primaryColor, primary: AppColors.primaryColor),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 5,
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          5,
        ),
      ),
    ),
  ),
);
