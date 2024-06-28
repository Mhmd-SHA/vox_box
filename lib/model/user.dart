class UserData {
  final String email; // Use secure storage for email
  final String name;
  final String uid;
  final String? imageUrl; // Allow imageUrl to be null

  UserData({
    required this.email,
    required this.name,
    required this.uid,
    this.imageUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        email: json['email'] as String,
        name: json['name'] as String,
        uid: json['uid'] as String,
        imageUrl: json['imageUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'email': email, // Include email but prioritize secure storage
        if (imageUrl != null) 'imageUrl': imageUrl,
      };
}
