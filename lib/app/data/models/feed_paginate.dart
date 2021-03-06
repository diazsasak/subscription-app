import 'dart:convert';

import 'package:subscription_app/app/data/models/feed.dart';

class FeedPaginate {
  FeedPaginate({
    this.total,
    this.feeds,
  });

  int total;
  List<Feed> feeds;

  factory FeedPaginate.fromJson(String str) =>
      FeedPaginate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FeedPaginate.fromMap(Map<String, dynamic> json) => FeedPaginate(
        total: json['total'],
        feeds: List<Feed>.from(json['feeds'].map((x) => Feed.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'total': total,
        'feeds': List<dynamic>.from(feeds.map((x) => x.toMap())),
      };

  // if there are remaining feed not loaded, we add 1 space for the loading progress at the bottom of list view
  int get itemCount => total > feeds.length ? feeds.length + 1 : feeds.length;

  bool shouldShowLoadMoreProgress(int index) => total > feeds.length && index == feeds.length;
}
