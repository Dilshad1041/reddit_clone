// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Comments {
  final String id;
  final String text;
  final DateTime createdAt;
  final String postId;
  final String userName;
  final String profilePic;
  Comments({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.postId,
    required this.userName,
    required this.profilePic,
  });

  Comments copyWith({
    String? id,
    String? text,
    DateTime? createdAt,
    String? postId,
    String? userName,
    String? profilePic,
  }) {
    return Comments(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      postId: postId ?? this.postId,
      userName: userName ?? this.userName,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'postId': postId,
      'userName': userName,
      'profilePic': profilePic,
    };
  }

  factory Comments.fromMap(Map<String, dynamic> map) {
    return Comments(
      id: map['id'] as String,
      text: map['text'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      postId: map['postId'] as String,
      userName: map['userName'] as String,
      profilePic: map['profilePic'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comments.fromJson(String source) =>
      Comments.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comments(id: $id, text: $text, createdAt: $createdAt, postId: $postId, userName: $userName, profilePic: $profilePic)';
  }

  @override
  bool operator ==(covariant Comments other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.postId == postId &&
        other.userName == userName &&
        other.profilePic == profilePic;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        createdAt.hashCode ^
        postId.hashCode ^
        userName.hashCode ^
        profilePic.hashCode;
  }
}
