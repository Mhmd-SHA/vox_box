import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String reciverId;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderId,
      required this.senderEmail,
      required this.reciverId,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "senderEmail": senderEmail,
      "reciverId": reciverId,
      "message": message,
      "timestamp": timestamp,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        senderId: json['senderId'] as String,
        senderEmail: json['senderEmail'] as String,
        reciverId: json['reciverId'] as String,
        message: json['message'] as String,
        timestamp: json['timestamp'] as Timestamp,
      );
}
