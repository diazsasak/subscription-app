import 'dart:convert';

class Feed {
  Feed({
    this.id,
    this.feedName,
    this.subscriptionId,
  });

  int id;
  String feedName;
  String subscriptionId;

  factory Feed.fromJson(String str) => Feed.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Feed.fromMap(Map<String, dynamic> json) => Feed(
        id: json["id"],
        feedName: json["feedName"],
        subscriptionId: json["subscriptionId"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "feedName": feedName,
        "subscriptionId": subscriptionId,
      };
}
