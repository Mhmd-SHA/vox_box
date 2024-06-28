import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:vox_box/const/app_colors/app_colors.dart';
import 'package:vox_box/model/chat_room.dart';
import 'package:vox_box/provider/chat_provider.dart';

import '../../const/appsizes/app_size.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.chatRoom}) : super(key: key);

  ChatRoom chatRoom;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();

  bool isShown = false;
  FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  scrollDown() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: Durations.long4,
      curve: Curves.fastEaseInToSlowEaseOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatPro, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: Get.back,
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.whiteColor,
                )),
            title: Text(widget.chatRoom.chatName),
          ),
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.lightBackroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSize.containerBorderRadius),
                topRight: Radius.circular(AppSize.containerBorderRadius),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //
                  Expanded(
                    child: StreamBuilder(
                      stream: chatPro.getMessages(
                        Chatroom: widget.chatRoom,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        if (!snapshot.hasData) {}
                        // if (snapshot.connectionState == ConnectionState.waiting) {
                        //   return Center(
                        //     child: CircularProgressIndicator(),
                        //   );
                        // }
                        if (snapshot.hasData) {
                          // return ListView(
                          //   children: [
                          //     ...snapshot.data!.docs.map(
                          //       (e) {
                          //         final chat = e.data() as Map<String, dynamic>;
                          //         print(chat['message']);
                          //         return ChatBubble(chatData: chat);
                          //       },
                          //     ).toList(),
                          //   ],
                          // );

                          return ListView.builder(
                              reverse: true,
                              controller: scrollController,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                int itemCount = snapshot.data!.docs.length;
                                int reversedIndex = itemCount - 1 - index;

                                final MessageData =
                                    snapshot.data!.docs[reversedIndex].data()
                                        as Map<String, dynamic>;

                                bool isRight = MessageData['senderId'] ==
                                    chatPro.authService.firebaseAuth
                                        .currentUser!.uid;
                                return Align(
                                  alignment: isRight
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Container(
                                    margin: EdgeInsets.all(2),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isRight
                                          ? Colors.greenAccent.shade700
                                          : Colors.blueGrey.shade100,
                                      borderRadius: isRight
                                          ? BorderRadius.only(
                                              topLeft: Radius.circular(AppSize
                                                  .containerBorderRadius),
                                              topRight: Radius.circular(AppSize
                                                  .containerBorderRadius),
                                              bottomLeft: Radius.circular(
                                                  AppSize
                                                      .containerBorderRadius))
                                          : BorderRadius.only(
                                              bottomLeft: Radius.circular(
                                                  AppSize
                                                      .containerBorderRadius),
                                              topRight: Radius.circular(AppSize
                                                  .containerBorderRadius),
                                              bottomRight: Radius.circular(
                                                  AppSize
                                                      .containerBorderRadius),
                                            ),
                                    ),
                                    child: Text(
                                      MessageData['message'],
                                      // textAlign:
                                      //     isRight ? TextAlign.right : TextAlign.left,
                                    ),
                                  ),
                                );
                              });
                        }
                        return SizedBox();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: TextFormField(
                      // onTap: () {
                      //   Future.delayed(
                      //     Durations.extralong1,
                      //     () => scrollDown(),
                      //   );
                      // },
                      focusNode: focusNode,
                      controller: messageController,
                      onChanged: (value) {
                        print(value);
                        if (!value.isNotEmpty) {
                          setState(() {
                            isShown = false;
                          });
                        }
                        if (value.isNotEmpty) {
                          setState(() {
                            isShown = true;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          IconlyBroken.chat,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            // authProvider.showPassword();
                            if (messageController.text.isNotEmpty) {
                              chatPro.sendMessage(
                                Chatroom: widget.chatRoom,
                                messageContent: messageController.text,
                              );
                              messageController.clear();

                              Future.delayed(
                                Durations.extralong4,
                                () => scrollDown(),
                              );
                            }
                          },
                          icon: isShown
                              ? Icon(
                                  IconlyBold.send,
                                  color: Colors.blue,
                                )
                              : Icon(
                                  IconlyBold.send,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade400,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 25),
                        hintText: 'Type a message',
                      ),
                      style: TextStyle(
                          // fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  )
                  // _chatListScreen( ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
