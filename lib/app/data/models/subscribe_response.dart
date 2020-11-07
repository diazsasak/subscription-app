// To parse this JSON data, do
//
//     final subscribeResponse = subscribeResponseFromMap(jsonString);

import 'dart:convert';

class SubscribeResponse {
  SubscribeResponse({
    this.id,
    this.feedId,
  });

  String id;
  int feedId;

  factory SubscribeResponse.fromJson(String str) =>
      SubscribeResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubscribeResponse.fromMap(Map<String, dynamic> json) =>
      SubscribeResponse(
        id: json["id"],
        feedId: json["feedId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "feedId": feedId,
      };
}
