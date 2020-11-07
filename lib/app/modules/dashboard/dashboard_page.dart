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
        title: Obx(
          () => ctrl.isSearch.value
              ? TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search by feed name',
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  onChanged: (String v) => ctrl.filterByFeedName(feedName: v),
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                )
              : Text('Dashboard'),
        ),
        actions: [
          Obx(() => ctrl.isSearch.value
              ? IconButton(icon: Icon(Icons.clear), onPressed: ctrl.clearSearch)
              : IconButton(icon: Icon(Icons.search), onPressed: ctrl.setSearch))
        ],
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text('Number of Subscribed Feed'),
                                    Text(
                                      "${ctrl.getSubscribedFeedAmount()}",
                                      style: TextStyle(fontSize: 30.0),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: ctrl.feedPaginate.feeds.length == 0
                                  ? Center(
                                      child: Text('Empty.'),
                                    )
                                  : ListView.builder(
                                      itemCount: ctrl.feedPaginate.total >
                                              ctrl.feedPaginate.feeds.length
                                          ? ctrl.feedPaginate.feeds.length + 1
                                          : ctrl.feedPaginate.feeds.length,
                                      itemBuilder: (context, index) {
                                        if (ctrl.feedPaginate.total >
                                                ctrl.feedPaginate.feeds
                                                    .length &&
                                            index ==
                                                ctrl.feedPaginate.feeds
                                                    .length) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        return FeedListItem(
                                          feed: ctrl.feedPaginate.feeds[index],
                                          onPressed: () => ctrl.toggleSubscribe(
                                            feed:
                                                ctrl.feedPaginate.feeds[index],
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
