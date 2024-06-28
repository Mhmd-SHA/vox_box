import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vox_box/const/appsizes/app_size.dart';
import 'package:vox_box/provider/chat_provider.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({Key? key, required this.hintText, required this.controller})
      : super(key: key);
  String hintText;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatPro, child) {
        return Form(
          key: chatPro.boxFormKey,
          child: TextFormField(
            controller: controller,
            maxLines: 1,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => chatPro.validate(value!),
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppSize.containerBorderRadius),
              ),
            ),
          ),
        );
      },
    );
  }
}
