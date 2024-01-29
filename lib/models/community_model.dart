import 'dart:convert';

import 'package:flutter/foundation.dart';

class Community {
  final String id;
  final String name;
  final String avatar;
  final String banner;
  final List<String> members;
  final List<String> mods;

  Community({
    required this.id,
    required this.name,
    required this.avatar,
    required this.banner,
    required this.members,
    required this.mods,
  });

  Community copyWith({
    String? id,
    String? name,
    String? avatar,
    String? banner,
    List<String>? members,
    List<String>? mods,
  }) {
    return Community(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      banner: banner ?? this.banner,
      members: members ?? this.members,
      mods: mods ?? this.mods,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'avatar': avatar,
      'banner': banner,
      'members': members,
      'mods': mods,
    };
  }

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      id: map['id'] as String,
      name: map['name'] as String,
      avatar: map['avatar'] as String,
      banner: map['banner'] as String,
      members: (map['members'] as List<dynamic>).cast<String>(),
      mods: (map['mods'] as List<dynamic>).cast<String>(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Community.fromJson(String source) =>
      Community.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Community(id: $id, name: $name, avatar: $avatar, banner: $banner, members: $members, mods: $mods)';
  }

  @override
  bool operator ==(covariant Community other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.avatar == avatar &&
        other.banner == banner &&
        listEquals(other.members, members) &&
        listEquals(other.mods, mods);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        avatar.hashCode ^
        banner.hashCode ^
        members.hashCode ^
        mods.hashCode;
  }
}
