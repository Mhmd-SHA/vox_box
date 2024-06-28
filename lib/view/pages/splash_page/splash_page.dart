import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vox_box/const/app_colors/app_colors.dart';
import 'package:vox_box/provider/chat_provider.dart';
import 'package:vox_box/view/pages/login_page/login_page.dart';

import '../home_page/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ChatProvider>(context, listen: false);

    Future.delayed(Duration(seconds: 2), () {
      if (provider.authService.firebaseAuth.currentUser != null) {
        Get.off(() => HomePage());
      } else {
        Get.offAll(() => LoginPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
          Shimmer.fromColors(
            baseColor: AppColors.primaryColor.withOpacity(0.5),
            highlightColor: Colors.white,
            child: Center(
              child: SizedBox(
                height: 140,
                width: 140,
                child: Image.asset(
                  "assets/logo.png",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
