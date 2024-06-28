import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  String chatRoomID;
  String chatName;
  String createdBy;
  Timestamp createdAt;

  ChatRoom({
    required this.chatRoomID,
    required this.chatName,
    required this.createdBy,
    required this.createdAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) => ChatRoom(
        chatRoomID: json['chatRoomID'] as String,
        chatName: json['chatName'] as String,
        createdBy: json['createdBy'] as String,
        createdAt: json['createdAt'] as Timestamp,
      );

  Map<String, dynamic> toJson() => {
        'chatRoomID': chatRoomID,
        'chatName': chatName,
        'createdBy': createdBy,
        'createdAt': createdAt,
      };
}
