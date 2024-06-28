import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:vox_box/provider/chat_provider.dart';

import '../../../../const/app_colors/app_colors.dart';
import '../../../../const/appsizes/app_size.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/custom_text_field.dart';

class AppFloatingActionBar extends StatefulWidget {
  const AppFloatingActionBar({Key? key}) : super(key: key);

  @override
  _AppFloatingActionBarState createState() => _AppFloatingActionBarState();
}

class _AppFloatingActionBarState extends State<AppFloatingActionBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatPro, child) {
        return SpeedDial(
          icon: Icons.add,
          iconTheme: IconThemeData(color: AppColors.whiteColor, size: 30),
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.containerBorderRadius),
          ),
          overlayOpacity: 0,
          // spacing: 15,
          children: [
            SpeedDialChild(
              label: "Join a Box",
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              onTap: () {
                Get.defaultDialog(
                  title: "Join a Box",
                  titleStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  content: CustomTextField(
                    controller: chatPro.boxIdController,
                    hintText: "Box ID",
                  ),
                  confirm: AppButton(
                      onPress: () {
                        if (chatPro.boxFormKey.currentState!.validate()) {
                          chatPro.joinChatRoom(
                              BoxName: chatPro.boxIdController.text);
                          Get.back();

                          chatPro.clearFields();
                        }
                      },
                      buttonText: "Join"),
                );
              },
            ),
            SpeedDialChild(
              label: "Create New Box",
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              onTap: () {
                Get.defaultDialog(
                  title: "Create New Box",
                  titleStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  content: CustomTextField(
                    controller: chatPro.boxNameController,
                    hintText: "Box Name",
                  ),
                  confirm: AppButton(
                      onPress: () {
                        if (chatPro.boxFormKey.currentState!.validate()) {
                          print(chatPro.boxNameController.text);
                          chatPro.addChatRoom();
                          Get.back();
                          chatPro.clearFields();
                        }
                      },
                      buttonText: "Join"),
                );
              },
            ),

            // SpeedDialChild(
            //   labelWidget: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text("Create New Box"),
            //       SizedBox(),
            //       Text("Join a Box"),
            //     ],
            //   ),
            //   onTap: () {},
            // ),
          ],
        );
      },
    );
  }
}
