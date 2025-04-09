library arcane_fcm_models;

import 'package:dart_mappable/dart_mappable.dart';

mixin ArcaneFCMMessage {
  String get user;
  Map<String, dynamic> toMap();
}

class FCMDeviceHook extends MappingHook {
  @override
  Object? beforeDecode(Object? value) =>
      value is Map<String, dynamic> ? FCMDeviceInfo.fromMap(value) : value;
  @override
  Object? beforeEncode(Object? value) =>
      value is FCMDeviceInfo ? value.toMap() : value;
}

class FCMDeviceInfo {
  final String token;
  final String hash;
  final String platform;
  final DateTime createdAt;

  FCMDeviceInfo({
    required this.token,
    required this.hash,
    required this.platform,
    required this.createdAt,
  });

  factory FCMDeviceInfo.fromMap(Map<String, dynamic> map) => FCMDeviceInfo(
    token: map["token"],
    hash: map["hash"],
    platform: map["platform"],
    createdAt: DateTime.fromMillisecondsSinceEpoch(
      map["createdAt"],
      isUtc: true,
    ),
  );

  Map<String, dynamic> toMap() => {
    "token": token,
    "hash": hash,
    "platform": platform,
    "createdAt": createdAt.millisecondsSinceEpoch,
  };
}
