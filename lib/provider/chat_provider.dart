import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vox_box/model/chat_room.dart';
import 'package:vox_box/services/Auth_service.dart';
import 'package:vox_box/services/chat_service.dart';
import 'package:vox_box/view/pages/home_page/home_page.dart';
import 'package:vox_box/view/pages/login_page/login_page.dart';

import '../model/messagee.dart';

class ChatProvider extends ChangeNotifier {
  // ChatProvider(){
  //
  // }
  AuthService authService = AuthService();
  ChatService chatService = ChatService();
  final boxFormKey = GlobalKey<FormState>();
  TextEditingController boxNameController = TextEditingController();
  TextEditingController boxIdController = TextEditingController();

  List<ChatRoom> chatRooms = [];

  // User Authentication Logics
  void signinWithGoogle() async {
    try {
      UserCredential? userCredential = await authService.singInWithGoogle();
      if (authService.firebaseAuth.currentUser != null) {
        await chatService.addUser(userCredential: userCredential!);
        Get.offAll(() => HomePage());
        EasyLoading.showSuccess(
          "Login Successful",
        );
      }
    } catch (e) {
      EasyLoading.showError(e.toString());
      print(e.toString());
    }
    notifyListeners();
  }

  void signout() async {
    try {
      await authService.signOut();
      if (authService.firebaseAuth.currentUser == null) {
        Get.offAll(() => LoginPage());
        EasyLoading.showSuccess("LogOut Successful");
      }
    } catch (e) {
      print(e.toString());
      EasyLoading.showError(e.toString());
    }
    notifyListeners();
  }

// Chat Management Logics

  void addChatRoom() async {
    try {
      await chatService.createChatRoom(
        userId: authService.firebaseAuth.currentUser!.uid,
        chatName: boxNameController.text,
      );
    } catch (e) {
      print(e.toString());
      print("Chat Room Creation Failed ${e.toString()}");
      EasyLoading.showSuccess("Chat Room Creation Failed");
    }
    notifyListeners();
  }

  void joinChatRoom({required String BoxName}) async {
    try {
      await chatService.JoinChatRoom(
        userId: authService.firebaseAuth.currentUser!.uid,
        chatName: BoxName,
      );
    } catch (e) {
      EasyLoading.showError("Chat Room Join Failed");
    }
    notifyListeners();
  }

  Future<List<ChatRoom>?> getAllChatRooms() async {
    try {
      final collectionRef =
          chatService.firebaseFirestore.collection('ChatRoom');
      final querySnapshot = await collectionRef.get();

      // Extract chat room data from documents
      final chatRooms = querySnapshot.docs
          .map((doc) => ChatRoom.fromJson(doc.data()))
          .toList();

      return chatRooms;
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
    return null;
  }

  Future<List<ChatRoom>?> getJoinedChats() async {
    try {
      final collectionRef = chatService.firebaseFirestore.collection('Users');
      final querySnapshot = await collectionRef
          .doc(authService.firebaseAuth.currentUser!.uid)
          .collection("JoinedChatRooms")
          .get();

      final chatRooms = querySnapshot.docs
          .map((doc) => ChatRoom.fromJson(doc.data()))
          .toList();

      return chatRooms;
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
  }

  void clearFields() {
    boxNameController.clear();
    boxIdController.clear();
    notifyListeners();
  }

  validate(String value) {
    if (value.isEmpty) {
      return 'Box Id or Name Cannot be empty';
    }
    if (value.length < 5) {
      return 'ust be at least 5 characters long';
    }
    return null;
  }

  Future<bool> isUserInChatRoom({required String BoxName}) async {
    try {
      final collectionRef =
          await chatService.firebaseFirestore.collection('ChatRoom');
      final participantsRef =
          await collectionRef.doc(BoxName).collection('Participants');

      // Check if user already exists
      final documentSnapshot = await participantsRef.get();
      if (documentSnapshot == authService.firebaseAuth.currentUser!.uid) {
        return true;
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
    }
    return false;
    notifyListeners();
  }

  ///
  ///
  ///
  ///
  ///
  /// /MEssages

  //send Message
  Future<void> sendMessage(
      {required String messageContent, required ChatRoom Chatroom}) async {
    try {
      String currentId = authService.firebaseAuth.currentUser!.uid;
      String currentEmail = authService.firebaseAuth.currentUser!.email!;
      final Timestamp timestamp = Timestamp.now();

      Message message = Message(
          senderId: currentId,
          senderEmail: currentEmail,
          reciverId: Chatroom.chatRoomID,
          message: messageContent,
          timestamp: timestamp);

      await chatService.firebaseFirestore
          .collection("ChatRoom")
          .doc(Chatroom.chatName)
          .collection("Messages")
          .add(message.toMap());

      //
    } catch (e) {
      print(e);
    }
  }

//getMessages
  Stream<QuerySnapshot> getMessages({required ChatRoom Chatroom}) {
    return chatService.firebaseFirestore
        .collection("ChatRoom")
        .doc(Chatroom.chatName)
        .collection("Messages")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
