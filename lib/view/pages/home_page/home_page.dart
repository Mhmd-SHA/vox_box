import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:vox_box/const/app_colors/app_colors.dart';
import 'package:vox_box/const/appsizes/app_size.dart';
import 'package:vox_box/provider/chat_provider.dart';
import 'package:vox_box/view/pages/home_page/components/app_floating_action_bar.dart';
import '../../../services/Auth_service.dart';
import '../chat_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var pro = Provider.of<ChatProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatPro, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                chatPro.authService.firebaseAuth.currentUser?.photoURL
                        .toString() ??
                    "",
              ),
            ),
            title: Text("My Boxes"),
            actions: [
              IconButton(
                onPressed: () => chatPro.signout(),
                icon: Icon(Icons.logout),
              ),
            ],
          ),
          body: !chatPro.chatRooms.isEmpty
              ? Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightBackroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSize.containerBorderRadius),
                      topRight: Radius.circular(AppSize.containerBorderRadius),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "Please Create a new Box or Join to exist one",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightBackroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSize.containerBorderRadius),
                      topRight: Radius.circular(AppSize.containerBorderRadius),
                    ),
                  ),
                  child: FutureBuilder(
                    future: chatPro.getJoinedChats(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          padding: EdgeInsets.only(top: 15),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            if (snapshot.hasData) {
                              var filteredList = snapshot.data?.map(
                                (e) async {
                                  return await chatPro.isUserInChatRoom(
                                      BoxName: e.chatName);
                                },
                              ).toList();
                              print(filteredList!.length);
                              var chatRoom = snapshot.data![index];

                              // var isAvailable = await chatPro.isUserInChatRoom(
                              //     BoxName: chatRoom.chatName);

                              return ListTile(
                                onTap: () {
                                  Get.to(
                                    () => ChatPage(
                                      chatRoom: chatRoom,
                                    ),
                                  );
                                },
                                contentPadding:
                                    EdgeInsets.only(left: 25, right: 20),
                                title: Text(
                                  chatRoom.chatName,
                                  maxLines: 2,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppColors.primaryColor,
                                  size: 20,
                                ),
                                tileColor:
                                    AppColors.primaryColor.withOpacity(1),
                              );
                            }
                          },
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
          floatingActionButton: AppFloatingActionBar(),
        );
      },
    );
  }
}
