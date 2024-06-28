import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:vox_box/const/app_colors/app_colors.dart';
import 'package:vox_box/const/appsizes/app_size.dart';
import 'package:vox_box/provider/chat_provider.dart';
import 'package:vox_box/services/Auth_service.dart';
import 'package:vox_box/utils/app_text_styles.dart';
import 'package:vox_box/view/pages/home_page/home_page.dart';
import 'package:vox_box/view/widgets/login_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatPro, child) {
        return Scaffold(
          body: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: AppSize.verticalPadding,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.only(
                        topRight:
                            Radius.circular(AppSize.containerBorderRadius),
                        topLeft:
                            Radius.circular(AppSize.containerBorderRadius)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 35),
                      Text(
                        "Login to Continue",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 35),
                      LoginButton(
                          onPress: () => chatPro.signinWithGoogle(),
                          buttonText: "Continue with Google"),
                      SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 140,
                  width: 140,
                  child: Hero(
                    tag: "logo",
                    child: Image.asset(
                      "assets/logo.png",
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
