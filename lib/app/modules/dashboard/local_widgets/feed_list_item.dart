import 'package:flutter/material.dart';
import 'package:subscription_app/app/data/models/feed.dart';

class FeedListItem extends StatelessWidget {
  final Feed feed;
  final Function onSubscribedPressed;

  FeedListItem({this.feed, this.onSubscribedPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const FlutterLogo(size: 30),
              const SizedBox(width: 10),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(feed.feedName),
                  if (feed.subscriptionId != null)
                    Text(
                      'Subscription ID: ${feed.subscriptionId}',
                      style: const TextStyle(fontSize: 10.0),
                    ),
                ],
              )),
              InkWell(
                onTap: onSubscribedPressed,
                child: feed.subscriptionId == null
                    ? Text(
                        'SUBSCRIBE',
                        key: Key('subscribe_button_${feed.id}'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      )
                    : Text(
                        'UNSUBSCRIBE',
                        key: Key('unsubscribe_button_${feed.id}'),
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
