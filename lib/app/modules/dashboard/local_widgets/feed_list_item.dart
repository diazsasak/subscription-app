import 'package:flutter/material.dart';
import 'package:subscription_app/app/data/models/feed.dart';

class FeedListItem extends StatelessWidget {
  final Feed feed;
  final Function onPressed;

  FeedListItem({this.feed, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlutterLogo(size: 30),
              SizedBox(width: 10),
              Expanded(child: Text(feed.feedName)),
              InkWell(
                onTap: onPressed,
                child: feed.subscriptionId == null
                    ? Text(
                        'SUBSCRIBE',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      )
                    : Text(
                        'UNSUBSCRIBE',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
