import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vox_box/model/chat_room.dart';
import 'package:vox_box/model/user.dart';

class ChatService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addUser({required UserCredential userCredential}) async {
    try {
      CollectionReference collectionRef = firebaseFirestore.collection("Users");
      await collectionRef.doc(userCredential.user!.uid).set(
            UserData(
              email: userCredential.user!.email!,
              name: userCredential.user!.displayName!,
              uid: userCredential.user!.uid,
              imageUrl: userCredential.user!.photoURL,
            ).toJson(),
          );
    } catch (e) {
    }
  }

  Future<void> createChatRoom(
      {required String userId, required String chatName}) async {
    try {
      var collectionRef = firebaseFirestore.collection("ChatRoom");
      var userCollectionRef = firebaseFirestore.collection("Users");
      var chat = await collectionRef.doc(chatName).get();
      if (chat.exists) {
        EasyLoading.showError("Chat room already exists");
        throw Exception("Chat room already exists");
      } else {
        var data = ChatRoom(
          chatRoomID: collectionRef.doc().id,
          chatName: chatName,
          createdBy: userId,
          createdAt: Timestamp.now(),
        ).toJson();
        await collectionRef.doc(chatName).set(data);
        await userCollectionRef
            .doc(userId)
            .collection("JoinedChatRooms")
            .doc(chatName)
            .set(data);
        // var p = await getParticipantUserIds(chatName);
        // print(p);
        EasyLoading.showSuccess("Chat room Created ");
      }
    } catch (e) {
    }
  }


  Future<void> JoinChatRoom(
      {required String userId, required String chatName}) async {
    try {
      var ChatcollectionRef = firebaseFirestore.collection("ChatRoom");
      final collectionRef = firebaseFirestore.collection('Users');
      final participantsRef =
          collectionRef.doc(userId).collection('JoinedChatRooms');

      // Check if user already exists
      final documentSnapshot = await participantsRef.doc(chatName).get();
      final documentSnapshotchrom = await ChatcollectionRef.doc(chatName).get();
      if (documentSnapshot.exists) {
        EasyLoading.showError("User already joined chat room");
        throw Exception('User already joined chat room: $chatName');
      } else if (documentSnapshotchrom.exists) {
        var data = ChatRoom(
          chatRoomID: ChatcollectionRef.doc().id,
          chatName: chatName,
          createdBy: userId,
          createdAt: Timestamp.now(),
        ).toJson();
        await participantsRef.doc(chatName).set(data);
        EasyLoading.showSuccess("Chat Room Joined Successfully");
      } else {
        throw Exception('Chat Box not found');
      }


    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
      } else {
      }
    }
  }

  Future<List<ChatRoom>?> getAllChatRooms() async {
    try {
      final collectionRef = firebaseFirestore.collection('ChatRoom');
      final querySnapshot = await collectionRef.get();

      final chatRooms = querySnapshot.docs
          .map((doc) => ChatRoom.fromJson(doc.data()))
          .toList();

      return chatRooms;
    } catch (e) {
    }
  }

  Future<List<ChatRoom>?> getJoinedChats({
    required String userid,
  }) async {
    try {
      final collectionRef = firebaseFirestore.collection('Users');
      final querySnapshot =
          await collectionRef.doc(userid).collection("JoinedChatRooms").get();

      final chatRooms = querySnapshot.docs
          .map((doc) => ChatRoom.fromJson(doc.data()))
          .toList();

      return chatRooms;
    } catch (e) {
    }
  }
}
