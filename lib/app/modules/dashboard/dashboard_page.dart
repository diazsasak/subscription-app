import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subscription_app/app/modules/dashboard/dashboard_controller.dart';
import 'package:subscription_app/app/modules/dashboard/local_widgets/feed_list_item.dart';

class DashboardPage extends StatelessWidget {
  final ctrl = DashboardCtrl.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Obx(
        () => ctrl.isLoading && ctrl.feedPaginate == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ctrl.feedPaginate == null
                ? Center(
                    child: FlatButton(
                      child: Text(
                        'Get Feeds',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => ctrl.getFeedList(initial: true),
                      color: Colors.blue,
                    ),
                  )
                : ctrl.feedPaginate.feeds.length == 0
                    ? Center(
                        child: Text('Empty.'),
                      )
                    : NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification sn) {
                          if (sn.metrics.pixels >=
                                  (sn.metrics.maxScrollExtent - 200) &&
                              ctrl.feedPaginate.total >
                                  ctrl.feedPaginate.feeds.length) {
                            ctrl.getFeedList(initial: false);
                          }
                          return true;
                        },
                        child: RefreshIndicator(
                          onRefresh: () => ctrl.getFeedList(initial: true),
                          child: ListView.builder(
                            itemCount: ctrl.feedPaginate.total >
                                    ctrl.feedPaginate.feeds.length
                                ? ctrl.feedPaginate.feeds.length + 1
                                : ctrl.feedPaginate.feeds.length,
                            itemBuilder: (context, index) {
                              if (ctrl.feedPaginate.total >
                                      ctrl.feedPaginate.feeds.length &&
                                  index == ctrl.feedPaginate.feeds.length) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return FeedListItem(
                                feed: ctrl.feedPaginate.feeds[index],
                                onPressed: () => ctrl.toggleSubscribe(
                                  feed: ctrl.feedPaginate.feeds[index],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
      ),
    );
  }
}
